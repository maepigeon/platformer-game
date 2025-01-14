extends Area2D

export var direction = true #right
export var action_after_collision = "flip"

func transition(body):
	if body.is_in_group("Players"):
		if direction:
			right()
		else:
			left()
		match action_after_collision:
			"flip":
				direction = !direction

func left():
	CameraEffects.left_transition()
	
func right():
	CameraEffects.right_transition()
