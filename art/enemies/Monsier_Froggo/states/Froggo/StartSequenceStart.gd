extends "../state.gd"

func enter():
	owner.get_node("Tongue").cast_to_player = true

func exit():
	print("exiting")
