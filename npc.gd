extends Area2D

@export var autoscroll: Vector2

enum COLORS { BLACK, GRAY, TABBY }
const ANIMATIONS = {
	COLORS.BLACK: 'black',
	COLORS.GRAY: 'gray',
	COLORS.TABBY: 'tabby'
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
	for sprite in $ColorSprites.get_children():
		if sprite.name.to_lower() != ANIMATIONS[color]:
			sprite.hide()
		else:
			sprite.show()

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
