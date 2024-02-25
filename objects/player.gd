extends Area2D

signal hit

@export var autoscroll: Vector2
@export var max_health: int
@export var disable_input: bool

const ACCELERATION = 400
const MAX_SPEED = 400
const FRICTION = 100

var screen_size
var velocity: Vector2
var health: int

func _ready():
	screen_size = get_viewport_rect().size

func start(pos):
	position = pos
	show()
	velocity = autoscroll
	health = max_health
	$DamageArea.disabled = false
	$AnimationPlayer.play("idle")
	$DamagedAnimationPlayer.stop()

func _physics_process(delta):
	var input_direction = Vector2(0, 0)
	var input_x
	var input_y
	if not disable_input:
		input_direction = Input.get_vector("left", "right", "up", "down")
		input_x = Input.get_axis("left", "right")
		input_y = Input.get_axis("up", "down")
	
	if input_direction.length() > 0:
		velocity += ACCELERATION * input_direction * delta
		velocity = velocity.limit_length(MAX_SPEED)
		$AnimationPlayer.play("swim")
	else:
		$AnimationPlayer.play("idle")
	
	if not input_x:
		rotation = 0
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	if not input_y:
		velocity.y = move_toward(velocity.y, autoscroll.y, FRICTION * delta)
	if input_x == -1:
		rotation = - PI / 8
	elif input_x == 1:
		rotation = PI / 8
	
	position += velocity * delta
	
	var player_bounds = $Sprite/SpriteArea.get_shape().get_rect().size
	
	# horizontal looping
	if position.x < -player_bounds.x / 2:
		position.x = screen_size.x + player_bounds.x / 2
	elif position.x > screen_size.x + player_bounds.x / 2:
		position.x = -player_bounds.x / 2

	# restrict vertical movement to screen height
	position.y = clamp(position.y, player_bounds.y / 2, screen_size.y - player_bounds.y / 2)
	if (position.y <= player_bounds.y / 2) or (position.y >= screen_size.y - player_bounds.y / 2):
		velocity.y = 0

func _on_area_entered(area):
	hit.emit(area)
