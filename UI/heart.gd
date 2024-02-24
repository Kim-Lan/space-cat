extends Control

var heart_full = preload("res://assets/icon_hp_full.png")
var heart_empty = preload("res://assets/icon_hp_empty.png")

func _ready():
	pass

func flash():
	$AnimationPlayer.play("flash")
