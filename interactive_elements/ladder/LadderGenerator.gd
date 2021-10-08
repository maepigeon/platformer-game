tool
extends "res://game_elements/VerticalTileGenerator.gd"

export var ladder : PackedScene setget set_ladder
export var top : PackedScene setget top_collider
export var bottom : PackedScene setget bottom_collider
export var offset = 0 setget set_offset

func set_offset(off):
	offset = off
	top_offset = off
	
func set_ladder(ladder_node):
	ladder = ladder_node
	main_element = ladder_node
func top_collider(top_node):
	top = top_node
	top_element = top_node
func bottom_collider(bottom_node):
	bottom = bottom_node
	bottom_element = bottom_node
