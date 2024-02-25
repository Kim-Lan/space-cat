extends Node

const AUTOSCROLL = Vector2(0.0, 50.0) # 50 pixels/sec downwards
const FREEZE_DURATION = 0.35

@export var npc_scene: PackedScene
@export var treat_scene: PackedScene

var highscore: int = 0

var score: int
var max_health: int = 3
var current_health: int

func _ready():
	load_highscore()
	$Player.hide()

func new_game():
	clear_screen()
	score = 0
	current_health = max_health
	$Player.start($StartPosition.position)
	$UI/InGameHUD.update_score(score)
	$UI/InGameHUD.draw_health(current_health)
	get_tree().paused = false
	
	$Player.autoscroll = AUTOSCROLL
	$Background.camera_velocity = AUTOSCROLL
	$Background.reset()
	$NPCTimer.start()
	$TreatTimer.start()
	$Player.disable_input = false

func game_over():
	get_tree().paused = true
	$FreezeTimer.stop()
	save_highscore()
	$Player/DamagedAnimationPlayer.stop()
	$NPCTimer.stop()
	$TreatTimer.stop()
	$UI.show_game_over(score)

func clear_screen():
	get_tree().call_group("npc_group", "queue_free")
	get_tree().call_group("treat_group", "queue_free")
	$Player.hide()

func spawn(scene):
	# create new instance of given scene
	var instance = scene.instantiate()
	
	# choose random location along SpawnPath
	var spawn_location = $SpawnPath/SpawnLocation
	spawn_location.progress_ratio = randf()
	
	# set instance position and velocity
	instance.position = spawn_location.position
	instance.rotation = randf_range(0, 2 * PI)
	instance.autoscroll = randf_range(0.60, 1.4) * AUTOSCROLL
	
	return instance

func _on_npc_timer_timeout():
	var npc = spawn(npc_scene)
	$NPCs.add_child(npc)

func _on_treat_timer_timeout():
	var treat = spawn(treat_scene)
	$Treats.add_child(treat)
	treat.collected.connect(_on_treat_collected)

func _on_treat_collected():
	score += 1
	$UI/InGameHUD.update_score(score)

func freeze_frame(duration):
	get_tree().paused = true
	if current_health > 0:
		$FreezeTimer.start(duration)

func _on_freeze_timer_timeout():
	get_tree().paused = false

func _on_player_hit(npc_area):
	if $BapCooldown.is_stopped() and current_health > 0:
		current_health -= 1
		npc_area.bap()
		$Audio/HitSound.play()
		freeze_frame(FREEZE_DURATION)
		
		if current_health <= 0:
			game_over()
		else:
			$Player/DamagedAnimationPlayer.play("damaged")
			$Player/DamageArea.set_deferred("disabled", true)
			$UI/InGameHUD.minus_health()
			$BapCooldown.start()

func _on_bap_cooldown_timeout():
	$Player/DamagedAnimationPlayer.stop()
	if current_health > 0:
		$Player/DamageArea.disabled = false

func save_highscore():
	var file = FileAccess.open("user://highscore.txt", FileAccess.WRITE)
	if score > highscore:
		highscore = score
		file.store_string(str(highscore))
		$UI.update_highscore(highscore)

func load_highscore():
	var file = FileAccess.open("user://highscore.txt", FileAccess.READ)
	if file != null:
		highscore = int(file.get_as_text())
	else:
		highscore = 0
	$UI.update_highscore(highscore)

func _on_reset_highscore():
	highscore = 0
	var file = FileAccess.open("user://highscore.txt", FileAccess.WRITE)
	file.store_string(str(highscore))
	$UI.update_highscore(highscore)
