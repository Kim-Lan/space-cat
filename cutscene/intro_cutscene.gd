extends Control

signal animation_finished
signal skip

var skipped: bool = false

func _ready():
	$Background.camera_velocity = Vector2(0, 0)
	$AnimationPlayer.play("animation")
	$AudioPlayer.play()

func _input(event):
	if event.is_action_pressed("space") and not skipped:
		$AnimationPlayer.stop()
		$AudioPlayer.stop()
		skipped = true
		skip.emit()

func _on_animation_finished(_anim_name):
	animation_finished.emit()
