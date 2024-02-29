extends Node

signal animation_finished

func _ready():
	$Background.camera_velocity = Vector2(0, 0)
	$AnimationPlayer.play("animation")

func _on_animation_finished(anim_name):
	animation_finished.emit()
