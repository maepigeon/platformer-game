extends "res://art/breakable-items/web/BreakablePlatform.gd"

export var vine_grower : NodePath
export var number_of_segments = 12
export var growthspeed = 2 #segments per second

func grow():
	for x in number_of_segments:
		yield(get_tree().create_timer(1 / growthspeed),"timeout")
		get_node(vine_grower).height = x
	
	yield(get_tree().create_timer(1 / growthspeed),"timeout")
	delete()
