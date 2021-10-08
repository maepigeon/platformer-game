extends KinematicBody2D

var target
var motion = Vector2.ZERO
var acceleration = Vector2.ZERO
var speed = 64
var steer_force = 35.0
export var enabled = true

signal destroy_arm

func _ready():
	target = PlayerStats.get_player()
	
func _physics_process(delta):
	if enabled:
		acceleration += seek()
		motion += acceleration * delta
		motion = motion.clamped(speed)
		rotation = motion.angle()
		position += motion * delta
		
func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.global_position - global_position).normalized() * speed
		steer = (desired - motion.normalized() * steer_force)
	return steer
	
func kill():
	motion = Vector2.ZERO
	acceleration = Vector2.ZERO
	target = null
	emit_signal("destroy_arm")
	$Particles2D.visible = true
	print("bomb destroyed")
	yield(get_tree().create_timer(1.0), "timeout")
	
	queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group("Players") and enabled:
		body.take_damage()
		kill()
	elif body.is_in_group("HomingMissiles") and body != self and body.enabled and enabled:
		kill()
