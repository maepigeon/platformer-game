extends KinematicBody2D

export var duration = 1.0
export var pause_time = 0.5
export var oscillate_amt = Vector2(64.0, 0)
export var time_offset = 0.25

onready var start_position = position
onready var end_position = start_position + oscillate_amt
var time = 0
onready var wait_time = time_offset 

func _physics_process(delta):
	if wait_time > 0:
		wait_time -= delta
		return
	if time < duration:
		time += delta
		position = lerp(start_position, end_position, time / duration)
	else:
		wait_time = pause_time
		time = 0
		var temp = end_position
		end_position = start_position
		start_position = temp


func _on_Area2D_body_entered(body):
	if body.is_in_group("HomingMissiles"):
		body.kill()
