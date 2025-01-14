extends KinematicBody2D
var direction
export var motion = Vector2(-1, 0) 
export var velocity = 48
export (PackedScene) var bomb
export var bomb_count = 1
export var oscillate_speed = 4
export var oscillate_intensity = 16
var time = 0
var bomb_cooldown = 0
var bomb_cooldown_value = 2
func _ready():
	bomb_cooldown = bomb_cooldown_value
	
func _physics_process(delta):
	time += delta 
	bomb_cooldown -= delta
	position += motion * delta * velocity
	position.y += oscillate_intensity * sin(time * oscillate_speed) * delta
	if $PlayerChecker.is_colliding() and bomb_count > 0 and bomb_cooldown < 0:
		drop_bomb()
		
func flip():
	scale.x = -scale.x
	velocity = -velocity
	print("flipped owl-o")
	
func take_damage(_amt):
	pass
		
func drop_bomb():
	bomb_count -= 1
	bomb_cooldown = bomb_cooldown_value
	var bullet = bomb.instance()
	bullet.direction = Vector2(0, 1)
	get_parent().add_child(bullet)
	bullet.position = position
