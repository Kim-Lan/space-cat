extends TextureRect

var heart_full = preload("res://assets/icon_hp_full.png")
var heart_empty = preload("res://assets/icon_hp_empty.png")

func _ready():
	texture = heart_full

func flash():
	$AnimationPlayer.play("damaged")

func _on_animation_player_animation_finished(anim_name):
	texture = heart_empty
