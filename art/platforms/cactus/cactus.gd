tool
extends "res://game_elements/VerticalTileGenerator.gd"

export var body : PackedScene setget set_base
export var head : PackedScene setget top_collider

func set_base(base_node):
	body = base_node
	main_element = base_node
func top_collider(top_node):
	head = top_node
	top_element = top_node
 
