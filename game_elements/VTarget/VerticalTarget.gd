extends Node2D

func get_new_camera_pos(player_pos):
	if -300 < player_pos and player_pos < -168:
		return -200
	elif -168 < player_pos and player_pos < -98:
		return -160
	elif -98 < player_pos and player_pos < 48:
		return -16
	elif 48 < player_pos and player_pos < 200:
		return 80
	else:
		return 0

func update_camera_y(_is_grounded):
	position.y = get_new_camera_pos(PlayerStats.get_player().position.y)
