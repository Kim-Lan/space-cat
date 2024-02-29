extends CanvasLayer

signal start_from_title
signal play_again
signal return_title
signal reset_high_score
signal pause_toggled
signal pause_screen_return_title

var ingame: bool
var paused: bool

func _ready():
	$TitleScreen.hide()
	$GameOverScreen.hide()
	$InGameHUD.hide()
	$PauseScreen.hide()
	$Timer.hide()
	ingame = false
	paused = false

func _input(event):
	if event.is_action_pressed("pause"):
		if ingame:
			if not paused:
				$SoundEffects/NemoPurrASound.play()
			else:
				$SoundEffects/MenuSound.play()
			toggle_pause()

func _process(_delta):
	if ingame and not paused and Input.is_action_pressed("space"):
		if not $SoundEffects/NPCTerritorySound.playing:
			$SoundEffects/NPCTerritorySound.play()
	else:
		if $SoundEffects/NPCTerritorySound.playing:
			$SoundEffects/NPCTerritorySound.stop()

func set_ingame(value):
	ingame = value

func update_score(value):
	$InGameHUD.set_score(value)
	$PauseScreen.set_current_score(value)

func toggle_pause():
	if not paused:
		get_tree().paused = true
		$PauseScreen.visible = true
		$PauseScreen.show_pause()
		$Music/InGameMusic.volume_db = -20
		$Timer.pause()
	else:
		get_tree().paused = false
		$PauseScreen.visible = false
		$Music/InGameMusic.volume_db = -6
		$Timer.unpause()
	paused = not paused
	pause_toggled.emit()

func stop_game():
	ingame = false
	$Timer.stop()
	$InGameHUD.hide()
	$Music/InGameMusic.stop()

func show_game_over(score):
	stop_game()
	$GameOverScreen.set_final_score(score)
	$GameOverScreen.find_child("PlayAgainButton").grab_focus()
	$GameOverScreen.show()
	$AnimationPlayer.play("game_over")
	$Music/EndMusic.play()

func update_high_score(value):
	if value == 69:
		value = "69 nice"
	$TitleScreen.set_high_score(value)
	$PauseScreen.set_high_score(value)
	$GameOverScreen.set_high_score(value)

func _on_start_button_pressed():
	$SoundEffects/StartSound.play()
	$TitleScreen.process_mode = Node.PROCESS_MODE_DISABLED
	$AnimationPlayer.play("start_from_title")
	start_from_title.emit()

func _on_play_again_button_pressed():
	$SoundEffects/StartSound.play()
	$GameOverScreen.hide()
	$InGameHUD.show()
	$Timer.reset()
	$AnimationPlayer.play("play_again")
	play_again.emit()

func _on_return_title_button_pressed():
	$AnimationPlayer.play("return_to_title")
	$GameOverScreen.hide()
	$Timer.hide()
	$TitleScreen.show()
	$TitleScreen.process_mode = Node.PROCESS_MODE_INHERIT
	$TitleScreen.find_child("StartButton").grab_focus()
	$Music/EndMusic.stop()
	return_title.emit()
	ingame = false
	await get_tree().create_timer(0.5).timeout
	$Music/TitleMusic.play()

func _on_reset_high_score_pressed():
	reset_high_score.emit()

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "title_fade_in"):
		$TitleScreen/TitleBackground.show()
		$TitleScreen/PlayerSprite.show()
		$TitleScreen/Buttons/StartButton.grab_focus()
		$IntroCutscene.queue_free()
		$Music/TitleMusic.play()
	elif (anim_name == "start_from_title"):
		$TitleScreen.hide()
		$Music/TitleMusic.stop()
	elif (anim_name == "return_to_title"):
		$InGameHUD.hide()
		$PauseScreen.hide()
		$GameOverScreen.hide()
		$Music/InGameMusic.stop()
		$Music/EndMusic.stop()
	elif anim_name == "play_again":
		$Music/EndMusic.stop()

func _on_pause_screen_return_title_confirmed():
	stop_game()
	toggle_pause()
	$InGameHUD.hide()
	_on_return_title_button_pressed()
	pause_screen_return_title.emit()

func _on_pause_screen_restart_confirmed():
	stop_game()
	toggle_pause()
	$Timer.reset()
	_on_play_again_button_pressed()

func _on_unpause():
	#$SoundEffects/NemoPurrASound.play()
	toggle_pause()

func _on_intro_cutscene_animation_finished():
	$TitleScreen.show()
	$AnimationPlayer.play("title_fade_in")

func _on_intro_cutscene_skip():
	$SoundEffects/MenuSound.play()
	$TitleScreen.modulate.a = 1
	$TitleScreen/TitleBackground.show()
	$TitleScreen/PlayerSprite.show()
	$TitleScreen.show()
	$Music/TitleMusic.play()
	await get_tree().create_timer(0.5).timeout
	$TitleScreen/Buttons/StartButton.grab_focus()
	$IntroCutscene.queue_free()

func _on_timer_area_entered(area):
	$Timer.modulate.a = 0.5

func _on_timer_area_exited(area):
	$Timer.modulate.a = 1
