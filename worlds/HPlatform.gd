extends Node2D

export var startPos = Vector2(180, 20)
export var endPos = Vector2(180, 100)

export var can_jump_through = false setget jump_through

var forwards = true

func jump_through(can_jump_thru):
	can_jump_through = can_jump_thru
	$MovingPlatform/platform/CollisionShape2D.one_way_collision = can_jump_through

func _ready():
	$MovingPlatform.set_pos(startPos)
	$MovingPlatform.follow =endPos
	$MovingPlatform._init_tween()

	visible = true

func _on_Timer_timeout():
	$Timer.stop()
	if forwards:
		$MovingPlatform.follow =startPos
	else:
		$MovingPlatform.follow  =endPos
	$MovingPlatform._init_tween()
	$MovingPlatform.on = true
	forwards = !forwards
	
func _on_MovingPlatform_at_location():
	$Timer.start()

