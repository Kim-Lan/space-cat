extends Control

signal play_again_button_pressed
signal return_title_button_pressed

func _ready():
	pass

func set_final_score(value):
	var final_score_str = str(value)
	if value == 69:
		final_score_str += " nice"
	find_child("FinalScoreValue").text = final_score_str
	for i in $DanceSprites.get_child_count():
		$DanceSprites.get_child(i).hide()
	for i in range(1, 14):
		if value > i * 20:
			$DanceSprites.get_child(i).show()
			if i == 1:
				$DanceAnimationPlayer.play("dance")
				$DanceSprites.get_child(0).show()
		else:
			break

func set_high_score(value):
	find_child("HighScoreValue").text = str(value)

func _on_play_again_button_pressed():
	$DanceAnimationPlayer.stop()
	play_again_button_pressed.emit()

func _on_return_title_button_pressed():
	$DanceAnimationPlayer.stop()
	return_title_button_pressed.emit()
