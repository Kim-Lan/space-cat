extends Area2D

@export var autoscroll: Vector2

enum COLORS { BLACK, GRAY, TABBY, SIAMESE, AEGEAN }
const ANIMATIONS = {
	COLORS.BLACK: 'Black',
	COLORS.GRAY: 'Gray',
	COLORS.TABBY: 'Tabby',
	COLORS.SIAMESE: 'Siamese',
	COLORS.AEGEAN: 'Aegean'
}
const STATS = {
	COLORS.BLACK: {
		'territory_radius': 200,
		'speed': 50
	},
	COLORS.GRAY: {
		'territory_radius': 300,
		'speed': 75
	},
	COLORS.TABBY: {
		'territory_radius': 200,
		'speed': 50
	},
	COLORS.SIAMESE: {
		'territory_radius': 200,
		'speed': 50
	},
	COLORS.AEGEAN: {
		'territory_radius': 200,
		'speed': 50
	}
}

enum STATES { EEPY, ANGY, BAP }

var color = 0
var state = 0
var speed = 50

var velocity: Vector2 = Vector2.ZERO
var angy: bool = false
var target: Area2D

func _ready():
	select_color()
	state = STATES.EEPY
	$AnimationPlayer.play("eepy")

func select_color():
	color = randi() % COLORS.size()
	select_sprite(color)
	set_stats(color)

func select_sprite(color):
	for sprite in $ColorSprites.get_children():
		if sprite.name != ANIMATIONS[color]:
			sprite.hide()
		else:
			sprite.show()

func set_stats(color):
	var radius = STATS[color]['territory_radius']
	var circle = CircleShape2D.new()
	circle.set_radius(radius)
	$TerritoryArea/TerritoryCollisionShape.set_shape(circle)
	speed = STATS[color]['speed']

func _physics_process(delta):
	if state == STATES.ANGY:
		var target_direction = target.position
		look_at(target_direction)
		velocity = transform.x * speed
	else:
		velocity = Vector2.ZERO
	position += (velocity + autoscroll) * delta

func get_angy(area):
	state = STATES.ANGY
	target = area
	$AnimationPlayer.play("angy")

func get_eepy():
	target = null
	state = STATES.EEPY
	$AnimationPlayer.play("eepy")

func _on_territory_area_exited(area):
	await get_tree().create_timer(0.01).timeout
	get_eepy()

func _on_area_entered(area):
	state = STATES.BAP
	$AnimationPlayer.play("bap")
	$HitSound.play()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "bap":
		freeze_frame(0.35)

func freeze_frame(duration):
	get_tree().paused = true
	$FreezeTimer.start(duration)

func _on_freeze_timer_timeout():
	get_tree().paused = false

func stop_timer():
	$FreezeTimer.paused = true

# delete itself once offscreen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
