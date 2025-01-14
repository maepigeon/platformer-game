extends Node2D

export var projectile : PackedScene
export var direction = Vector2(1, 0)
export var cooldown = 1
export var delay = 1
export var autofire =true
export var add_path : NodePath


func _ready():
	if (autofire):
		enable_autofire()
		
func enable_autofire():
	autofire =true
	var timer = Timer.new()
	timer.set_wait_time(delay)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "shoot")
	add_child(timer)
	timer.start()
	timer.set_wait_time(cooldown)
	
func shoot():
	var bullet = projectile.instance()
	if add_path:
		get_node(add_path).add_child(bullet)
		bullet.global_position = global_position
		print("success")
	else:
		add_child(bullet)
	bullet.direction = direction
	if $VisibilityNotifier2D.is_on_screen():
		$Pewsound.play()
