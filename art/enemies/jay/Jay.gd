extends KinematicBody2D
export var motion = Vector2.ZERO
export var motion_time = 2
export var moving = false

func _physics_process(delta):
	if moving:
		#rotation = motion.angle() + PI / 2
		rotation = motion.angle() - PI
		move_and_slide(motion, Vector2.UP)
		motion_time -= delta
		if motion_time < 0:
			take_damage(1)
		
func take_damage(_amt):
	print("killed the jay")
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Players") or body.is_in_group("Enemies"):
		body.take_damage(1)
