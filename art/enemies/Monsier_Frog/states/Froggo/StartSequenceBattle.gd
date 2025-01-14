extends "../state.gd"
func enter():
	owner.get_node("AnimationPlayer").play("StartSequenceBattle")
	print("this dialogue should only appear the first time you try the fight")
	print("Hahaha. I tricked you. I won't give you the tacos! You'll have to fight for them!")
	print("And you'll never beat me since my only weakness is is you ground pound my tongue.")
	print("Wait. Forget you heard that. I've said too much...")
	owner.get_node("Tongue").cast_to_player = false


func _on_animation_finished(_name):
	emit_signal("finished", "previous")

func exit():
	print("exiting state")
