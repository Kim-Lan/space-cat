extends CanvasLayer

signal start_game

const SCORE_LABEL = "score: "
var score: int

func _ready():
	$GameOverScreen.hide()
	$InGameHUD.hide()

func starting_game():
	update_score(0)
	$InGameHUD.show()
	start_game.emit()

func update_score(new_score):
	score = new_score
	$InGameHUD.update_score(score)

func show_game_over():
	$InGameHUD.hide()
	$GameOverScreen.set_score(score)
	$GameOverScreen.show()

func _on_start_button_pressed():
	$StartScreen.hide()
	starting_game()

func _on_play_again_button_pressed():
	$GameOverScreen.hide()
	starting_game()
