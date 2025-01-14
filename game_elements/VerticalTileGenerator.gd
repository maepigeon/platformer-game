tool
extends Node2D

export var height = 0 setget update_size
var main_element : PackedScene setget update_main_element
var top_element : PackedScene setget update_top_element
var bottom_element : PackedScene setget update_bottom_element
var tile_size = 16
var top_offset = 4


func update_top_element(top):
	if top == null:
		return
	top_element = top
	update_size(height)
	
func update_bottom_element(bottom):
	if bottom == null:
		return
	bottom_element = bottom
	update_size(height)
	
func update_main_element(main):
	if main ==null:
		return
	main_element = main
	update_size(height)

func update_size(new_size):
	if height == null or height < 0:
		height = 0
		print("height must be 0 or more!")
		return
	height = new_size
	if main_element == null:
		return
	for part in get_children():
		remove_child(part)
		part.queue_free()
	var y = 0
	y = int(top_offset)
	for i in range(height):
		var part
		if i == 0 and bottom_element != null:
			part = bottom_element.instance()
		elif i == height - 1 and top_element != null:
			part = top_element.instance()
			y -= top_offset
		else:
			part = main_element.instance()
		part.set_position(Vector2(0, y))
		add_child(part)
		y -= tile_size
