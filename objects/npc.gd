extends Area2D

@export var autoscroll: Vector2

enum TYPES { BLACK, GRAY, TABBY, SIAMESE, AEGEAN, COW, RAGDOLL, TORTOISE, WHITE, CALICO, CHIMERA, ORANGE, SOUPY }
const SPRITES = {
	TYPES.BLACK: 'Black',
	TYPES.GRAY: 'Gray',
	TYPES.TABBY: 'Tabby',
	TYPES.SIAMESE: 'Siamese',
	TYPES.AEGEAN: 'Aegean',
	TYPES.COW: 'Cow',
	TYPES.RAGDOLL: 'Ragdoll',
	TYPES.TORTOISE: 'Tortoise',
	TYPES.WHITE: 'White',
	TYPES.CALICO: 'Calico',
	TYPES.CHIMERA: 'Chimera',
	TYPES.ORANGE: 'Orange',
	TYPES.SOUPY: 'Soupy'
}
const STATS = {
	TYPES.BLACK: {
		'territory_radius': 75,
		'speed': 40
	},
	TYPES.TORTOISE: {
		'territory_radius': 100,
		'speed': 40
	},
	TYPES.GRAY: {
		'territory_radius': 250,
		'speed': 60
	},
	TYPES.WHITE: {
		'territory_radius': 300,
		'speed': 75
	},
	TYPES.TABBY: {
		'territory_radius': 150,
		'speed': 60
	},
	TYPES.RAGDOLL: {
		'territory_radius': 150,
		'speed': 50
	},
	TYPES.SIAMESE: {
		'territory_radius': 200,
		'speed': 60
	},
	TYPES.AEGEAN: {
		'territory_radius': 200,
		'speed': 50
	},
	TYPES.COW: {
		'territory_radius': 200,
		'speed': 40
	},
	TYPES.CALICO: {
		'territory_radius': 175,
		'speed': 50
	},
	TYPES.CHIMERA: {
		'territory_radius': 175,
		'speed': 50
	},
	TYPES.ORANGE: {
		'territory_radius': 100,
		'speed': 50
	},
	TYPES.SOUPY: {
		'territory_radius': 75,
		'speed': 60
	}
}

var type: int
var state: int
var territory_radius: int
var speed: int

var velocity: Vector2
var target: Area2D
var angy: bool

func _ready():
	select_type()
	get_eepy()

func _process(_delta):
	if Input.is_action_pressed("space"):
		$TerritoryCircle.set_visible(true)
	else:
		$TerritoryCircle.set_visible(false)

func select_type():
	type = randi() % TYPES.size()
	select_sprite(type)
	set_stats(type)

func select_sprite(selected):
	for sprite in $TypeSprites.get_children():
		if sprite.name != SPRITES[selected]:
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
