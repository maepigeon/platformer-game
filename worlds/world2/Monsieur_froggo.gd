extends KinematicBody2D

var wait_time = 0
var initial_player_pos = null
var final_player_pos = position
export var next_scene : PackedScene


func _ready():
	var timer = Timer.new()
	timer.connect("timeout",self,"_after_wait")
	add_child(timer) #to process
	timer.set_one_shot(true)
	timer.start(1) #to start
	
#game: tacocat
	
func _after_wait():
	print("frog: are you looking for the taco?")
	print("frog: its inside me, but I don't want it.")
	print("frog: you will have to come in to get it...")
	print("frog: haha I lied. I actually want the taco...")
	print("frog: you'll have to fight me for it")
	#TODO: add dialopue here
	var timer = Timer.new()
	timer.connect("timeout",self,"_eat_player")
	timer.set_one_shot(true)
	add_child(timer)
	timer.start(1)


func _eat_player():
	$Tongue.set_is_casting(true)
	$Tongue.cast_to_player = true
	$anim.play("open_mouth")
	var timer = Timer.new()
	timer.connect("timeout",self,"_pull_player")
	timer.set_one_shot(true)
	add_child(timer)
	timer.start(1)
	var player = PlayerStats.get_player()
	player.has_control = false
	
func _pull_player():
	$Tongue.set_is_casting(false)
	$Tongue.enable_physics_process()
	var player = PlayerStats.get_player()
	$Tween.interpolate_property(player, "position", player.position, \
		Vector2(position.x, player.position.y-7), 0.5, Tween.TRANS_LINEAR)
	$Tween.start()
	
	var timer = Timer.new()
	timer.connect("timeout",$anim,"play", ["default"])
	timer.set_one_shot(true)
	add_child(timer)
	timer.start(1)
	var timer2 = Timer.new()
	timer2.connect("timeout",self,"next_scene")
	timer2.set_one_shot(true)
	add_child(timer2)
	timer2.start(2)
	
func next_scene():
	SaveSystem.change_scene_to(next_scene, -1)
