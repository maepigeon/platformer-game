extends "res://interactive_elements/MovingPlatform.gd"


export var startPos = Vector2(180, 20)
export var endPos = Vector2(180, 100)

export var can_jump_through = false setget jump_through

var forwards = true

func jump_through(can_jump_thru):
	can_jump_through = can_jump_thru
	$platform/CollisionShape2D.one_way_collision = can_jump_through

func _ready():
	set_pos(startPos)
	follow =endPos
	_init_tween()

	visible = true

func _on_Timer_timeout():
	$Timer.stop()
	if forwards:
		follow =startPos
	else:
		follow  =endPos
	_init_tween()
	on = true
	forwards = !forwards
	$Timer.start()

