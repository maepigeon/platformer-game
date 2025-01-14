tool
extends "res://game_elements/VerticalTileGenerator.gd"

export var body : PackedScene setget set_base
export var head : PackedScene setget top_collider
export var tail : PackedScene setget set_tail
export var vel : Vector2 = Vector2(0, -16)
export var top_offset_amt = 0 setget update_top
var direction = -1 setget set_direction
var v = Vector2.ZERO

func set_direction(direction):
	v.y *= direction
	if direction < 0:
		rotation_degrees = 180

func _ready():
	update_size(height)
	update_top(top_offset_amt)
	v =vel

func update_top(amt):
	top_offset = amt
	update_top_element(head)

func set_base(base_node):
	body = base_node
	main_element = base_node
func top_collider(top_node):
	head = top_node
	top_element = top_node
func set_tail(bottom_node):
	tail = bottom_node
	bottom_element = bottom_node
	
func _process(delta):
	translate(v * delta)

func take_damage(__):
	queue_free()
