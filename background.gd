extends ParallaxBackground

@export var camera_velocity: Vector2

var front_layer_limit: int
var back_layer_limit: int

var screen_height: int

func _ready():
	screen_height = get_viewport().size.y
	front_layer_limit = 2 * screen_height
	back_layer_limit = 3 * screen_height
	reset()
	$BackLayer.set_visible(false)
	$FrontLayer.set_visible(false)

func reset():
	set_scroll_offset(Vector2(0,0))
	$FrontLayer.modulate.a = 0
	$BackLayer.modulate.a = 0
	$GradientLayer/Gradient.modulate.a = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_offset: Vector2 = get_scroll_offset() + camera_velocity * delta
	set_scroll_offset(new_offset)
	
	if new_offset.y > front_layer_limit:
		$FrontLayer.set_visible(true)
	if new_offset.y > back_layer_limit:
		$BackLayer.set_visible(true)
	
	if $GradientLayer/Gradient.modulate.a > 0:
		$GradientLayer/Gradient.modulate.a = clamp(1 - new_offset.y / screen_height, 0.0, 1.0)
	if $FrontLayer.modulate.a < 1:
		$FrontLayer.modulate.a = clamp((new_offset.y - front_layer_limit) / screen_height, 0.0, 1.0)
	if $BackLayer.modulate.a < 1:
		$BackLayer.modulate.a = clamp((new_offset.y - back_layer_limit) / screen_height, 0.0, 1.0)
