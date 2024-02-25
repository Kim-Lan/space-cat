extends Area2D

signal collected

@export var autoscroll: Vector2

var velocity: Vector2 = Vector2.ZERO
var is_big: bool
var value: int

func _ready():
	var type = randi() % 2 
	var rand_size = randf()
	is_big = rand_size < 0.1
	value = 3 if is_big else 1
	$CollisionShapeSmall.disabled = is_big
	$CollisionShapeBig.disabled = not is_big
	if rand_size < 0.1:
		type += 2
	select_sprite(type)

func select_sprite(type):
	for i in $Sprites.get_child_count():
		if type == i:
			$Sprites.get_child(i).set_visible(true)
		else:
			$Sprites.get_child(i).set_visible(false)

func _physics_process(delta):
	position += (velocity + autoscroll) * delta

func _on_area_entered(_area):
	collected.emit(value)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
