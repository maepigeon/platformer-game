extends Node


var on = false
var time = 0
var start_time = 0
var current_size
var start_size = 0
var end_size = 0
var pos = 0


func _process(delta):
	if on == true:
		var smooth_step = 1 - time / start_time
		smooth_step = smooth_step * smooth_step * (3 - 2 * smooth_step)
		current_size = lerp(start_size, end_size, smooth_step)
		time -= delta
		circle(current_size, pos)
		if time < 0:
			on = false
			circle(800, pos)

func door_transition(_pos):
	circle_transition(.8, 1.5, .1, _pos)

func circle_transition(time, start_size, end_size, _pos):
	_pos -= Vector2(120, 80)
	_pos /= -160
	self.pos = _pos
	self.time = time
	start_time = time
	self.start_size = start_size
	self.end_size = end_size
	current_size = start_size
	on = true;
	

func circle(rad, _pos):
	$CanvasLayer/circle.get_material().set_shader_param("pos", _pos)
	$CanvasLayer/circle.material.set_shader_param("rad", rad)
