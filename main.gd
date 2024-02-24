extends Node

const AUTOSCROLL = Vector2(0.0, 50.0) # 50 pixels/sec downwards

@export var npc_scene: PackedScene
@export var treat_scene: PackedScene
var score
var max_health = 3
var current_health = 3

func _ready():
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
	get_tree().call_group("npc_group", "stop_timer")
	#get_tree().paused = true
	$Player/DamagedAnimationPlayer.stop()
	$Player.disable_input = true
	$BapCooldown.stop()
	$NPCTimer.stop()
	$TreatTimer.stop()
	$UI.show_game_over()

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
	
	# spawn instance
	add_child(instance)
	
	return instance

func _on_npc_timer_timeout():
	var npc = spawn(npc_scene)

func _on_treat_timer_timeout():
	var treat = spawn(treat_scene)
	treat.collected.connect(_on_treat_collected)

func _on_treat_collected():
	score += 1
	$UI/InGameHUD.update_score(score)

func _on_player_damaged():
	current_health -= 1
	$UI/InGameHUD.minus_health()
	$BapCooldown.start()
	
	if current_health <= 0:
		game_over()

func _on_bap_cooldown_timeout():
	$Player/DamagedAnimationPlayer.stop()
	if current_health > 0:
		$Player/DamageArea.disabled = false
