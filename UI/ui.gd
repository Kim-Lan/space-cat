extends CanvasLayer

signal start_game

func _ready():
	$GameOverScreen.hide()
	$InGameHUD.hide()

func starting_game():
	$InGameHUD.update_score(0)
	$InGameHUD.show()
	start_game.emit()

func show_game_over():
	$InGameHUD.hide()
	$GameOverScreen.set_score_label($InGameHUD/ScoreLabel.text)
	$GameOverScreen/PlayAgainButton.grab_focus()
	$GameOverScreen.show()

func _on_start_button_pressed():
	$StartScreen.hide()
	starting_game()

func _on_play_again_button_pressed():
	$GameOverScreen.hide()
	starting_game()
