extends KinematicBody2D

const VELX = 20
var velocity = Vector2()
export var direction = -1
export var detects_cliffs = false
var warned = false
var y_direction = -1
const STUN_TIME = .7
var hit_ground = false
var screen_shaked = false
var stun_time = 0

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction * y_direction
	$floor_checker.enabled = detects_cliffs

func _physics_process(delta):
	if is_on_wall() or not $floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		direction = - direction 
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction * y_direction
	if $player_checker.is_colliding():
		warned = true
	if warned:
		if $hit_ground_checker.is_colliding():
			hit_ground = true
		if hit_ground:
			if !screen_shaked:
				CameraEffects.shake(.2)
				screen_shaked = true
				direction = -direction
			stun_time += delta
			if stun_time > STUN_TIME:
				y_direction = 1
				rotation_degrees = 0
				velocity.x = VELX * direction
			else: 
				velocity.x = 0
		velocity.y += 20
	else:
		velocity.y -= 20
		velocity.x = VELX * direction

	velocity = move_and_slide(velocity, Vector2(0, 1))

func take_damage(damage):
	queue_free()

func _on_sides_checker_body_entered(body):
	if body.is_in_group("Players"):
		body.take_damage(1)

