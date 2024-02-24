extends CanvasLayer

signal start_button_pressed

func _ready():
	find_child("StartButton").grab_focus()
	$Title/AnimationPlayer.play("title")

func _on_start_button_pressed():
	start_button_pressed.emit()

func _on_animation_toggled(toggled_on):
	if toggled_on:
		$Title/AnimationPlayer.play("title")
	else:
		$Title/AnimationPlayer.stop()
		$Player/AnimationPlayer.stop()
