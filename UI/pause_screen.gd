extends Control

signal unpause
signal return_title_confirmed
signal restart_confirmed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_pause():
	var rand = randf()
	if rand < 0.01:
		$PauseMenu/PauseLabel.text = "pawsed"
	else:
		$PauseMenu/PauseLabel.text = "paused"
	$PauseMenu.show()
	$ConfirmRestart.hide()
	$ConfirmTitleReturn.hide()
	$PauseMenu.find_child("ContinueButton").grab_focus()

func set_current_score(value):
	find_child("CurrentScoreValue").text = str(value)

func set_high_score(value):
	find_child("HighScoreValue").text = str(value)

func _on_continue_button_pressed():
	$MenuSound.play()
	unpause.emit()

func _on_restart_button_pressed():
	$MenuSound.play()
	$PauseMenu.hide()
	$ConfirmRestart.show()
	$ConfirmRestart.find_child("NoButton").grab_focus()

func _on_confirm_restart_yes_button_pressed():
	restart_confirmed.emit()

func _on_confirm_restart_no_button_pressed():
	$MenuSound.play()
	show_pause()

func _on_return_title_button_pressed():
	$MenuSound.play()
	$PauseMenu.hide()
	$ConfirmTitleReturn.show()
	$ConfirmTitleReturn.find_child("NoButton").grab_focus()

func _on_confirm_title_yes_button_pressed():
	return_title_confirmed.emit()

func _on_confirm_title_no_button_pressed():
	$MenuSound.play()
	show_pause()
