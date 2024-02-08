extends Area2D

signal hit
@export var autoscroll: Vector2

const ACCELERATION = 400
const MAX_SPEED = 400
const FRICTION = 100

var screen_size
var velocity = Vector2.ZERO

func _ready():
	hide()
	screen_size = get_viewport_rect().size
	
func start(pos):
	position = pos
	show()
	velocity = autoscroll
	$HitBox.disabled = false

func _physics_process(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if input_direction.length() > 0:
		velocity += ACCELERATION * input_direction * delta
		velocity = velocity.limit_length(MAX_SPEED)
	
	var input_x = Input.get_axis("left", "right")
	var input_y = Input.get_axis("up", "down")
	if !input_x:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	if !input_y:
		velocity.y = move_toward(velocity.y, autoscroll.y, FRICTION * delta)
	
	position += velocity * delta
	
	var player_bounds = $SpriteBounds.get_shape().get_rect().size
	
	# horizontal looping
	if position.x < -player_bounds.x / 2:
		position.x = screen_size.x + player_bounds.x / 2
	elif position.x > screen_size.x + player_bounds.x / 2:
		position.x = -player_bounds.x / 2

	# restrict vertical movement to screen height
	position.y = clamp(position.y, player_bounds.y / 2, screen_size.y - player_bounds.y / 2)
	if (position.y <= player_bounds.y / 2) or (position.y >= screen_size.y - player_bounds.y / 2):
		velocity.y = 0

func _on_body_entered(body):
	hide()
	hit.emit()
	$HitBox.set_deferred("disabled", true)
