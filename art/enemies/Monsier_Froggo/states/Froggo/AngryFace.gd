extends "../state.gd"
func enter():
	#owner.get_node("AnimationPlayer").play("StartSequenceBattle")
	_on_animation_finished("angry_face")

func _on_animation_finished(_name):
	emit_signal("finished", "angry_face")

