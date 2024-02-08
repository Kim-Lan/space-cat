extends Area2D

var screen_size # size of game window
var velocity = Vector2.ZERO
@export var speed_increment = 400
@export var max_speed = 400

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if input_direction.length() > 0:
		velocity += speed_increment * input_direction * delta
		velocity = velocity.limit_length(max_speed)
	
	var player_bounds = $CollisionShape2D.get_shape().get_rect().size
	
	position += velocity * delta
	if position.x < -player_bounds.x / 2:
		position.x = screen_size.x + player_bounds.x / 2
	elif position.x > screen_size.x + player_bounds.x / 2:
		position.x = -player_bounds.x / 2

	position.y = clamp(position.y, player_bounds.y / 2, screen_size.y - player_bounds.y / 2)
	if (position.y <= player_bounds.y / 2) or (position.y >= screen_size.y - player_bounds.y / 2):
		velocity.y = 0
