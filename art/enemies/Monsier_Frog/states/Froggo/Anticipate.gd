extends "../state.gd"


func enter():
	if owner.iteration % 5 == 0 or owner.iteration % 5 == 2: 
		owner.anticipated_action = "jump"
	else:
		owner.anticipated_action = "tongue_attack"
	owner.anticipated_position = owner.random_valid_position()
	owner.face_direction(owner.anticipated_position - owner.current_position)
	owner.iteration += 1
	yield(get_tree().create_timer(1.2), "timeout")
	_on_animation_finished("anticipate")

func _on_animation_finished(_name):
	emit_signal("finished", "anticipate")

func exit():
	print("exiting state")
