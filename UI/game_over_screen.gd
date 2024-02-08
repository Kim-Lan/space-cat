extends CanvasLayer

signal play_again_button_pressed

func set_score_label(str):
	$ScoreLabel.text = str

func _on_play_again_button_pressed():
	play_again_button_pressed.emit()
