extends KinematicBody2D

var out = false
export var wait_time = .5
export var time_waited = 0

func _process(delta):
	time_waited += delta
	if time_waited > wait_time:
		time_waited = 0
		alternate()

func alternate():
	out = !out
	visible = out
	if out:
		$Anim.play("out")
	else:
		$Anim.play("in")

func _on_Area2D_body_entered(body):
	if body.is_in_group("Players"):
		body.take_damage(1)
	if body.is_in_group("HomingMissiles"):
		body.kill()
		print("destroying missile")
		
