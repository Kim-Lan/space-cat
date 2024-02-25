extends CanvasLayer

signal start_game
signal return_title
signal reset_highscore

func _ready():
	$TitleScreen.show()
	$GameOverScreen.hide()
	$InGameHUD.hide()

func starting_game():
	$InGameHUD.update_score(0)
	$InGameHUD.show()
	start_game.emit()

func show_game_over(score, highscore):
	$InGameHUD.hide()
	$GameOverScreen.set_final_score(score)
	$GameOverScreen.find_child("PlayAgainButton").grab_focus()
	$GameOverScreen.show()

func update_highscore(value):
	$TitleScreen.set_highscore(value)
	$GameOverScreen.set_highscore(value)

func _on_start_button_pressed():
	$TitleScreen.hide()
	starting_game()

func _on_play_again_button_pressed():
	$GameOverScreen.hide()
	starting_game()

func _on_return_title_button_pressed():
	$GameOverScreen.hide()
	$TitleScreen.show()
	return_title.emit()

func _on_reset_highscore_pressed():
	reset_highscore.emit()
