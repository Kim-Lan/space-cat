extends CanvasLayer

signal start_button_pressed

func _ready():
	$StartButton.grab_focus()

func _on_start_button_pressed():
	start_button_pressed.emit()
