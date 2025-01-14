extends KinematicBody2D

export var explode_time = 5 #how much time it will explode in if it doesnt hit something
export var speed_anim_time = 0.2  #how long it takes to play accelerating animation
export var damage = 1
export var direction = Vector2(0, 1)
export var affected_by_grav = false
export var velocity = 64

var started = false

func start():
	$Timer.wait_time = explode_time
	$SpeedTimer.wait_time = speed_anim_time
	$Timer.start()
	$SpeedTimer.start()
	$AnimatedSprite.play("default")
	
func _process(delta):
	if !started:
		start()
		started = true
	rotation = direction.angle()
	position += direction * velocity * delta

func _on_Timer_timeout():
	take_damage(1)

	
func destroy_self():
	queue_free()

func _on_SpeedTimer_timeout():
	$AnimatedSprite.play("moving")

func take_damage(_amt):
	velocity = Vector2(0, 0)
	$AnimatedSprite.play("boom")
	
	destroy_self()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Players"):
		body.take_damage(damage)
	if body.is_in_group("BombSafe"):
		# things invincible to bombs
		return
	if body != self:
		take_damage(1)
