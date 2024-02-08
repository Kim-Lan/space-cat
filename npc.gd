extends Area2D

var velocity: Vector2

func _ready():
	$AnimatedSprite2D.set_animation("eepy")
	pass

func _physics_process(delta):
	position += velocity * delta

func _on_territory_area_entered(area):
	$AnimatedSprite2D.set_animation("angy")

func _on_territory_area_exited(area):
	$AnimatedSprite2D.set_animation("eepy")

# delete itself once offscreen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
