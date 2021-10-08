extends Area2D


func _on_Ladder_body_entered(body):
	if body.name == "Player":
		body.enter_ladder()
func _on_Ladder_body_exited(body):
	if body.name == "Player":
		body.exit_ladder()

