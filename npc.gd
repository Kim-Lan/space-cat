extends Area2D

@export var autoscroll: Vector2

var speed = 50

var velocity: Vector2 = Vector2.ZERO
var angy: bool = false
var target: Area2D

func _ready():
	$AnimatedSprite2D.set_animation("eepy")
	pass

func _physics_process(delta):
	if angy:
		var target_direction = target.position
		look_at(target_direction)
		velocity = transform.x * speed
	else:
		velocity = Vector2.ZERO
	position += (velocity + autoscroll) * delta

func _on_territory_area_entered(area):
	angy = true
	target = area
	$AnimatedSprite2D.set_animation("angy")

func _on_territory_area_exited(_area):
	angy = false
	$AnimatedSprite2D.set_animation("eepy")

# delete itself once offscreen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
