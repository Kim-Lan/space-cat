extends Node2D

@export var radius: float

func _draw():
	draw_circle(Vector2(0, 0), radius, Color(1, 0, 0, 0.05))
