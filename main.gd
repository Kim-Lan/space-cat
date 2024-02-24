extends Node

const AUTOSCROLL = Vector2(0.0, 50.0) # 50 pixels/sec downwards

@export var npc_scene: PackedScene
@export var treat_scene: PackedScene
var score

func _ready():
	pass

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$UI/InGameHUD.update_score(score)
	$UI/InGameHUD.update_health($Player.health)
	get_tree().call_group("npc_group", "queue_free")
	get_tree().call_group("treat_group", "queue_free")
	get_tree().paused = false	
	
	$Player.autoscroll = AUTOSCROLL
	$Background.camera_velocity = AUTOSCROLL
	$NPCTimer.start()
	$TreatTimer.start()

func game_over():
	$UI.show_game_over()
	$NPCTimer.stop()
	$TreatTimer.stop()
	
	get_tree().call_group("npc_group", "stop_timer")

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

func _on_player_damaged(health: int):
	$UI/InGameHUD.update_health(health)
