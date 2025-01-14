extends "../state.gd"


func enter():
	owner.get_node("AnimationPlayer").play("StartSequenceBattle")
	print("froggo devouring player")


func _on_animation_finished(_name):
	emit_signal("finished", "devour_player")

func exit():
	print("exiting state")
