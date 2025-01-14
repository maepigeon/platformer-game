extends KinematicBody2D

var player 
var firing = false
var default_acceleration = 32.0
var acceleration = 32.0
var speed = 0



func _ready():
	player = PlayerStats.get_player()
	$Gun.add_path = @"../.."

func _process(_delta):
	var dy = player.position.y - position.y
	if (dy != 0):
		acceleration = default_acceleration * dy / abs(dy)
	
	if abs(dy) > 40 and not firing:
		enable_firing()
	if abs(dy) > 80:
		acceleration = dy / 2.5
		
	if firing:
		if abs(dy) > 2:
			speed += acceleration * _delta
		else:
			speed = 0
		notice_player_move(_delta)

func notice_player_move(delta):
	var timer = Timer.new()
	timer.set_wait_time(0.6)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "unsurprise")
	$surprised.visible = true
	
	
	position = Vector2(250, position.y + speed * delta)
	$anim.play("wall_slide")
	
func enable_firing():
	$Gun.enable_autofire()
	firing = true
	


# TODO: animate shoot a lightning thing from hands and slide up/down instead
# of just setting the position

func unsurprise():
	$surprised.visible = false
