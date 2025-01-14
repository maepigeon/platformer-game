"""
	The Anticipate state ends with a chance of the Attack state occuring. 
	It only affects the tongue object.
"""
extends "../state.gd"
func enter():
	owner.get_node("AnimationPlayer").play("StartSequenceBattle")
	var target_position = owner.anticipated_position
	
	var cast_position = Vector2(128*owner.direction, 0)
	owner.get_node("Tongue").cast_to(cast_position, 32)

func _on_animation_finished(_name):
	owner.get_node("anim").play("default")
	owner.get_node("Tongue").took_hit = false
	emit_signal("finished", "tongue_attack")
