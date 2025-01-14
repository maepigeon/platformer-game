extends KinematicBody2D

var velocity = Vector2()
export var direction = -1
export var detects_cliffs = false

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_checker.enabled = detects_cliffs

func _physics_process(delta):
	if is_on_wall() or not $floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		direction = - direction 
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction

	velocity.y += 20
	velocity.x = 50 * direction
	velocity = move_and_slide(velocity, Vector2(0, -1))

func take_damage(_amt):
	queue_free()

func _on_sides_checker_body_entered(body):
	if body.is_in_group("Players"):
		body.take_damage(1)

