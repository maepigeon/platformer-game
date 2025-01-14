extends Node2D

var player
export var y_pos = 96

func _ready():
	player = PlayerStats.get_player()

func _physics_process(delta):
	position = Vector2(player.position.x, y_pos)
