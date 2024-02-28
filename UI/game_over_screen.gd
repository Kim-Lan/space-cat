extends Control

signal play_again_button_pressed
signal return_title_button_pressed

func _ready():
	pass

func set_final_score(value):
	find_child("FinalScoreValue").text = str(value)
	$DanceSprites/Sprite1.hide()
	$DanceSprites/Sprite2.hide()
	$DanceSprites/Sprite3.hide()
	$DanceAnimationPlayer.play("dance")
	if value > 1:
		$DanceSprites/Sprite1.show()
	if value > 2:
		$DanceSprites/Sprite2.show()
	if value > 3:
		$DanceSprites/Sprite3.show()

func set_high_score(value):
	find_child("HighScoreValue").text = str(value)

func _on_play_again_button_pressed():
	$DanceAnimationPlayer.stop()
	play_again_button_pressed.emit()

func _on_return_title_button_pressed():
	$DanceAnimationPlayer.stop()
	return_title_button_pressed.emit()
