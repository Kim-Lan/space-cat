extends ParallaxBackground

@export var camera_velocity: Vector2

var screen_size

func _ready():
	screen_size = get_viewport().size
	$BackLayer.set_visible(false)
	$FrontLayer.set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_offset: Vector2 = get_scroll_offset() + camera_velocity * delta
	set_scroll_offset(new_offset)
