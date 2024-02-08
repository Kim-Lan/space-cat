extends CanvasLayer

signal play_again_button_pressed

const SCORE_LABEL = "score: "

func set_score(score):
	$ScoreLabel.text = SCORE_LABEL + str(score)


func _on_play_again_button_pressed():
	play_again_button_pressed.emit()
