extends Node

const AUTOSCROLL = Vector2(0.0, 50.0) # 50 pixels/sec downwards
const FREEZE_DURATION = 0.35

@export var npc_scene: PackedScene
@export var treat_scene: PackedScene

var high_score: int = 0

var score: int
var max_health: int = 3
var current_health: int

var paused: bool = false

func _ready():
	load_high_score()
	$Player.position = $StartPosition.position
	$Player.disable_input = true

func _on_start_from_title():
	$StartDelay.start(1.5)
	starting_game()

func _on_play_again():
	$StartDelay.start(0.001)
	starting_game()

func _on_return_title():
	$SoundEffects/TreatSoundBig.play()
	reset_screen()
	$Player.disable_input = true

func starting_game():
	reset_screen()
	score = 0
	current_health = max_health
	$UI.update_score(score)
	$UI/InGameHUD.draw_health(current_health)
	$Background.reset()

func reset_screen():
	get_tree().call_group("npc_group", "queue_free")
	get_tree().call_group("treat_group", "queue_free")
	$Player/DamagedAnimationPlayer.stop()
	$Player.show()
	$Player.position = $StartPosition.position
	$Player.velocity = Vector2(0, 0)
	$Player.autoscroll = Vector2(0, 0)
	get_tree().paused = false

func _on_start_delay_timeout():
	$UI/Music/InGameMusic.play()
	start_game()
	$UI.set_ingame(true)

func start_game():
	$Player.autoscroll = AUTOSCROLL
	$Background.camera_velocity = AUTOSCROLL
	$NPCTimer.start()
	$TreatTimer.start()
	$Player.start()
	$UI/Timer.show()
	$UI/Timer.start()

func stop_game():
	$FreezeTimer.stop()
	save_high_score()
	$Player/DamagedAnimationPlayer.stop()
	$Player.velocity = Vector2(0, 0)
	$NPCTimer.stop()
	$TreatTimer.stop()

func game_over():
	get_tree().paused = true
	stop_game()
	$UI.show_game_over(score)

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

func _on_treat_collected(value):
	if value == 1:
		$SoundEffects/TreatSoundSmall.play()
	else:
		$SoundEffects/TreatSoundBig.play()
	score += value
	$UI.update_score(score)

func freeze_frame(duration):
	get_tree().paused = true
	if current_health > 0:
		$FreezeTimer.start(duration)

func _on_freeze_timer_timeout():
	if not paused:
		get_tree().paused = false

func _on_player_hit(npc_area):
	if $BapCooldown.is_stopped() and current_health > 0:
		current_health -= 1
		npc_area.bap()
		$SoundEffects/HitSound.play()
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

func save_high_score():
	if score > high_score:
		var file = FileAccess.open("user://high_score.txt", FileAccess.WRITE)
		high_score = score
		file.store_string(str(high_score))
		$UI.update_high_score(high_score)
		file.close()

func load_high_score():
	var file = FileAccess.open("user://high_score.txt", FileAccess.READ)
	if file != null:
		var text = file.get_as_text()
		if text == "pp":
			high_score = 69
		else:
			high_score = int(file.get_as_text())
	else:
		high_score = 0
	$UI.update_high_score(high_score)
	file.close()

func _on_reset_high_score():
	high_score = 0
	var file = FileAccess.open("user://high_score.txt", FileAccess.WRITE)
	file.store_string(str(high_score))
	$UI.update_high_score(high_score)
	file.close()

func _on_pause_toggled():
	paused = not paused

func _on_pause_screen_return_title():
	stop_game()
