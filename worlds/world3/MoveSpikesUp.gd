extends Node2D

var time =1
var deltay = 120
onready var start_position = position


func move_up():
	set_physics_process(true)
	
func _physics_process(delta):
	if abs(start_position.y + deltay - position.y) < .001:
		set_physics_process(false)
		print("boom")
	position = position.move_toward(start_position + Vector2(0, deltay), deltay * delta)
