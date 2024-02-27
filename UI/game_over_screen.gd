extends Control

signal play_again_button_pressed
signal return_title_button_pressed

func _ready():
	pass

func set_final_score(value):
	find_child("FinalScoreValue").text = str(value)

func set_highscore(value):
	find_child("HighScoreValue").text = str(value)

func _on_play_again_button_pressed():
	play_again_button_pressed.emit()

func _on_return_title_button_pressed():
	return_title_button_pressed.emit()
