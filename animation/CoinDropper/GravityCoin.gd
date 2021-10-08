extends "res://art/breakable-items/jar/items/Coin.gd"

const grav = 256
var velocity = 32

func _ready():
	$AnimationPlayer.play("Default")

func _physics_process(delta):
	velocity += grav * delta
	position = Vector2(position.x, velocity * delta + position.y)
	
