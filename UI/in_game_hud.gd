extends CanvasLayer

@export var heart_scene: PackedScene

var current_health: int

func update_score(value):
	$HUD/Score/ScoreLabel.text = str(value)

func update_health(value):
	for i in $HUD/HealthBar.get_child_count():
		$HUD/HealthBar.get_child(i).visible = value > i
	#$HealthLabel.text = HEALTH_LABEL + str(value)

func draw_health(value):
	get_tree().call_group("hearts", "queue_free")
	current_health = value
	for i in value:
		var heart = heart_scene.instantiate()
		$HUD/HealthBar.add_child(heart)

func minus_health():
	current_health -= 1
	var last_heart = $HUD/HealthBar.get_child(current_health)
	last_heart.flash()
