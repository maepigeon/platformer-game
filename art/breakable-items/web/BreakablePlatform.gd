extends StaticBody2D

export var anim_name = "New Anim"

func _on_Area2D_body_entered(body):
	if body.is_in_group("Players") and body.mode =="ground_pounding" and body.air_time > 0:
		CameraEffects.crush_web_sound()
		break_wall()

func break_wall():
	$Anim.play(anim_name)
	
func delete():
	queue_free()
