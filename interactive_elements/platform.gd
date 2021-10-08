extends KinematicBody2D


var velocity = Vector2.ZERO
var old_pos = Vector2.ZERO

func _process(_delta):
	#velocity = global_position - old_pos
	pass
	#old_pos = global_position
