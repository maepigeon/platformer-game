extends Node2D
signal at_location

const IDLE_DURATION =1.0
var timer = 0

var move_to = Vector2.RIGHT * 192
export var speed = 3.0

export var follow = Vector2.ZERO

onready var platform = $platform
onready var tween = $MoveTween

export var on = true

func set_pos(pos):
	platform.position = pos

		
func _init_tween():
	on = true
	var duration = move_to.length() / float(speed * 16)
	timer = IDLE_DURATION
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION)

func _physics_process(delta):
	if on:
		timer -=delta
		platform.position = platform.position.linear_interpolate(follow, 0.075)
		
		if (timer <= 0):
			on = false
			emit_signal("at_location")
