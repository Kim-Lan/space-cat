extends CanvasLayer

signal play_again_button_pressed
signal return_title_button_pressed

func _ready():
	pass

func set_score_label(text):
	find_child("ScoreLabel").text = "score: " + text

func _on_play_again_button_pressed():
	play_again_button_pressed.emit()

func _on_return_title_button_pressed():
	return_title_button_pressed.emit()
