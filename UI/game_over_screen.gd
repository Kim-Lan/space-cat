extends CanvasLayer

signal play_again_button_pressed

func set_score_label(text):
	$ScoreLabel.text = text

func _on_play_again_button_pressed():
	play_again_button_pressed.emit()
