extends Node

func _ready():
	$Background.camera_velocity = Vector2(0, 0)
	$AnimationPlayer.play("animation")
