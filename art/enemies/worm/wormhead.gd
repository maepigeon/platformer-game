extends KinematicBody2D

func _on_Area2D_body_entered(body):
	if body.is_in_group("Players") or body.is_in_group("Enemies"):
		body.take_damage(1)
