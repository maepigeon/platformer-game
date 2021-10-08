extends "../state.gd"


func enter():
	owner.get_node("AnimationPlayer").play("StartSequenceBattle")
	owner.take_damage(1)
	print("froggo taking damage")


func _on_animation_finished(_name):
	emit_signal("finished", "previous")

func exit():
	print("exiting state")
