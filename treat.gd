extends RigidBody2D

signal collected

func _ready():
	pass

# delete itself once offscreen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_2d_area_entered(area):
	queue_free()
	collected.emit()
