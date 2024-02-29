extends Control

var running: bool
var paused: bool
var time_start
var time_now
var time_elapsed
var time_paused = 0
var time_pause_start
var time_pause_end

func reset():
	time_elapsed = 0
	time_paused = 0
	update_label()
	$AnimationPlayer.stop()

func start():
	reset()
	time_start = Time.get_ticks_msec()
	time_now = Time.get_ticks_msec()
	running = true
	paused = false

func pause():
	if running:
		time_pause_start = Time.get_ticks_msec()
		paused = true
		$AnimationPlayer.play("flash")

func unpause():
	if running:
		time_pause_end = Time.get_ticks_msec()
		time_paused += (time_pause_end - time_pause_start)
		paused = false
		$AnimationPlayer.stop()

func stop():
	running = false

func _process(_delta):
	if running and not paused:
		time_now = Time.get_ticks_msec()
		time_elapsed = time_now - time_start - time_paused
		update_label()

func format_time(time: int):
	var minutes = time / 60 / 1000
	var seconds = (time / 1000) % 60
	#var milliseconds = time % 1000
	var format_string = "%02d:%02d"
	return format_string % [minutes, seconds]

func update_label():
	var time_str = format_time(time_elapsed)
	$TimeLabel.text = time_str
