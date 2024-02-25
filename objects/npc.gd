extends Area2D

@export var autoscroll: Vector2

enum COLORS { BLACK, GRAY, TABBY, SIAMESE, AEGEAN }
const ANIMATIONS = {
	COLORS.BLACK: 'Black',
	COLORS.GRAY: 'Gray',
	COLORS.TABBY: 'Tabby',
	COLORS.SIAMESE: 'Siamese',
	COLORS.AEGEAN: 'Aegean',
}
const STATS = {
	COLORS.BLACK: {
		'territory_radius': 75,
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
	},
}

var color: int
var state: int
var territory_radius: int
var speed: int

var velocity: Vector2
var target: Area2D
var angy: bool

func _ready():
	select_color()
	get_eepy()

func _process(_delta):
	if Input.is_action_pressed("space"):
		$TerritoryCircle.set_visible(true)
	else:
		$TerritoryCircle.set_visible(false)

func select_color():
	color = randi() % COLORS.size()
	select_sprite(color)
	set_stats(color)

func select_sprite(selected):
	for sprite in $ColorSprites.get_children():
		if sprite.name != ANIMATIONS[selected]:
			sprite.hide()
		else:
			sprite.show()

func set_stats(selected):
	speed = STATS[selected]['speed']
	territory_radius = STATS[selected]['territory_radius']
	var circle = CircleShape2D.new()
	circle.set_radius(territory_radius)
	$TerritoryArea/TerritoryCollisionShape.set_shape(circle)
	$TerritoryCircle.radius = territory_radius

func _physics_process(delta):
	if angy:
		var target_direction = target.position
		look_at(target_direction)
		velocity = transform.x * speed
	else:
		velocity = Vector2.ZERO
	position += (velocity + autoscroll) * delta

func get_angy(area):
	angy = true
	target = area
	$AnimationPlayer.play("angy")

func get_eepy():
	angy = false
	target = null
	$AnimationPlayer.play("eepy")

func _on_territory_area_exited(_area):
	await get_tree().create_timer(0.1).timeout
	get_eepy()

func bap():
	$BapAnimationPlayer.play("bap")

func draw_territory():
	$TerritoryCircle.visible = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
