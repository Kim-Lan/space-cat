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
	$Player.autoscroll = AUTOSCROLL
	$NPCTimer.start()
	$TreatTimer.start()

func game_over():
	$HUD.show_game_over()
	$NPCTimer.stop()
	$TreatTimer.stop()

func spawnArea2D(scene):
	# create new instance of given scene
	var instance = scene.instantiate()
	
	# choose random location along SpawnPath
	var spawn_location = $SpawnPath/SpawnLocation
	spawn_location.progress_ratio = randf()
	
	# set instance position and velocity
	instance.position = spawn_location.position
	instance.rotation = randf_range(0, 2 * PI)
	instance.velocity = AUTOSCROLL
	
	# spawn instance
	add_child(instance)
	
	return instance

func _on_npc_timer_timeout():
	spawnArea2D(npc_scene)

func _on_treat_timer_timeout():
	var treat = spawnArea2D(treat_scene)
	treat.collected.connect(_on_treat_collected)

func _on_treat_collected():
	score += 1
	$HUD.update_score(score)

func _on_player_hit():
	game_over()
