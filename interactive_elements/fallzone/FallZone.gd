extends Area2D

export var start_collision_size : Vector2

func _on_FallZone_body_entered(body):
	if body.is_in_group("Players"):
		body.game_over()
