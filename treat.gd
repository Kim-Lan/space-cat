extends Area2D

signal collected

@export var autoscroll: Vector2

var velocity: Vector2 = Vector2.ZERO

func _ready():
	var type = randi() % 2
	var texture = load("res://assets/treat/treat_" + str(type + 1) + ".png")
	$Sprite2D.texture = texture

func _physics_process(delta):
	position += (velocity + autoscroll) * delta

# delete itself once offscreen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(_area):
	queue_free()
	collected.emit()
