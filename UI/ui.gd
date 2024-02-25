extends CanvasLayer

#signal start_game
signal start_button_pressed
signal return_title
signal reset_highscore

func _ready():
	$TitleScreen.show()
	$GameOverScreen.hide()
	$InGameHUD.hide()

func starting_game():
	$InGameHUD.update_score(0)
	$InGameHUD.show()
	#start_game.emit()

func show_game_over(score):
	$InGameHUD.hide()
	$GameOverScreen.set_final_score(score)
	$GameOverScreen.find_child("PlayAgainButton").grab_focus()
	$GameOverScreen.show()

func update_highscore(value):
	$TitleScreen.set_highscore(value)
	$GameOverScreen.set_highscore(value)

func _on_start_button_pressed():
	$StartSound.play()
	$AnimationPlayer.play("start_from_title")
	start_button_pressed.emit()
	#starting_game()

func _on_play_again_button_pressed():
	$GameOverScreen.hide()
	starting_game()

func _on_return_title_button_pressed():
	$GameOverScreen.hide()
	$TitleScreen.show()
	$TitleScreen.find_child("StartButton").grab_focus()
	return_title.emit()

func _on_reset_highscore_pressed():
	reset_highscore.emit()

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "title_fade_out"):
		$TitleScreen.hide()
