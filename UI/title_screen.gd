extends CanvasLayer

signal start_button_pressed
signal reset_highscore_pressed

func _ready():
	find_child("StartButton").grab_focus()
	$Title/AnimationPlayer.play("title")
	$PlayerSprite.play()

func _on_start_button_pressed():
	start_button_pressed.emit()

func update_highscore(value):
	find_child("HighScoreValue").text = str(value)

func _on_reset_highscore_button_pressed():
	reset_highscore_pressed.emit()

func _on_animation_toggled(toggled_on):
	if toggled_on:
		$Title/AnimationPlayer.play("title")
		$PlayerSprite.play()
	else:
		$Title/AnimationPlayer.stop()
		$PlayerSprite.stop()
