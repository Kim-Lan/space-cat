extends CanvasLayer

#signal start_game
signal start_from_title
signal play_again
signal return_title
signal reset_highscore

func _ready():
	$TitleScreen.show()
	$GameOverScreen.hide()
	$InGameHUD.hide()

func show_game_over(score):
	$InGameHUD.hide()
	$GameOverScreen.process_mode = Node.PROCESS_MODE_INHERIT
	$GameOverScreen.set_final_score(score)
	$GameOverScreen.find_child("PlayAgainButton").grab_focus()
	$GameOverScreen.show()

func update_highscore(value):
	$TitleScreen.set_highscore(value)
	$GameOverScreen.set_highscore(value)

func _on_start_button_pressed():
	$StartSound.play()
	$AnimationPlayer.play("start_from_title")
	start_from_title.emit()

func _on_play_again_button_pressed():
	$StartSound.play()
	$GameOverScreen.process_mode = Node.PROCESS_MODE_DISABLED
	$GameOverScreen.hide()
	$InGameHUD.show()
	play_again.emit()

func _on_return_title_button_pressed():
	$AnimationPlayer.play("return_to_title")
	$GameOverScreen.hide()
	$GameOverScreen.process_mode = Node.PROCESS_MODE_DISABLED
	$TitleScreen.process_mode = Node.PROCESS_MODE_INHERIT
	$TitleScreen.show()
	$TitleScreen.find_child("StartButton").grab_focus()
	return_title.emit()

func _on_reset_highscore_pressed():
	reset_highscore.emit()

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "title_fade_out"):
		$TitleScreen.hide()
