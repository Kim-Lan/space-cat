extends Control

signal start_button_pressed
signal reset_high_score_pressed

func _ready():
	find_child("StartButton").grab_focus()
	$Title/AnimationPlayer.play("title")
	$PlayerSprite.play()

func _on_start_button_pressed():
	$FocusControl.grab_focus()
	start_button_pressed.emit()

func set_high_score(value):
	find_child("HighScoreValue").text = str(value)

func _on_reset_high_score_button_pressed():
	reset_high_score_pressed.emit()

func _on_animation_toggled(toggled_on):
	if toggled_on:
		$Title/AnimationPlayer.play("title")
		$PlayerSprite.play()
	else:
		$Title/AnimationPlayer.stop()
		$PlayerSprite.stop()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "fade_out"):
		hide()
