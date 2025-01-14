extends "res://interactive_elements/MovingPlatform.gd"

export var rotation_speed = 90 #90 degrees per second
export var wait_time = 0.0
export var alternating = true
var rotation_direction = true #true is clockwise, false is counterclockwise
export var start_rotation = 0
export var end_rotation = 90
onready var time = 0
var time_to_wait = 0.0


func _init():
	rotation = deg2rad(start_rotation)
	rotation_direction =  end_rotation < start_rotation

func _physics_process(delta):
	#._physics_process(delta)
	time_to_wait -= delta
	if time_to_wait <= 0: 
		time += delta
		rotate_platform()


func rotate_platform():
	if (($platform.rotation_degrees <= end_rotation and rotation_direction) or \
		($platform.rotation_degrees >= end_rotation and !rotation_direction)):
		$platform.rotation = deg2rad(lerp(start_rotation, end_rotation, \
			time * rotation_speed / 90))

	elif alternating:
		flip_direction()



func flip_direction():
	$platform.rotation = deg2rad(end_rotation)
	time_to_wait = wait_time
	var temp = start_rotation
	start_rotation = end_rotation
	rotation_direction = !rotation_direction
	end_rotation = temp
	time = 0
