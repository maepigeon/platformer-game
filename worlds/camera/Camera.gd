extends Node2D

#https://www.youtube.com/watch?v=CqU6w164AbU


onready var window_size = OS.get_window_size()
onready var player = get_parent().get_node("Player")
onready var player_world_pos = get_player_grid_pos()

func ready():
	var canvas_transform = get_viewport().get_canvas_transform()
	canvas_transform[2] = player_world_pos * window_size
	get_viewport().set_canvas_transform(canvas_transform)
	
func get_player_grid_pos():
	#converts the player position in px to their position on the world grid
	var pos = player.position
	var x = floor(pos.x / window_size.x)
	var y = floor(pos.y / window_size.y)
	return Vector2(x, y)
	
func _process(delta):
	#update_camera()
	pass
	
func update_camera():
	var new_player_grid_pos = get_player_grid_pos()
	var transform = Transform2D()
	
	if new_player_grid_pos != player_world_pos:
		player_world_pos = new_player_grid_pos
		transform = get_viewport().get_canvas_transform()
		transform[2] = -player_world_pos * window_size / 4
		print(window_size)
		get_viewport().set_canvas_transform(transform)
	
	return transform
