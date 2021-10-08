extends Node2D

export var tez_head : PackedScene
export var tez_arm : PackedScene
export var jay : PackedScene
export var tez_velocity = 128

export var spawn_range = 128 #pixels to the right
export var height = -128
var spawn_rate = 0.35 # jays per second
var jay_speed = 256

var hp = 3
var target_pos : Vector2
var missiles = 3
var shoot_index = 0
var current_missile_destroyed = true
var battle_started = false
var rng = RandomNumberGenerator.new()

var new_pos_time = 5.0
var new_pos_low_bounds = Vector2(1710, 80)
var new_pos_hi_bounds = Vector2(1900, 110)

var state = "waiting"

func _ready():
	rng.randomize()
	state = "waiting"


func take_damage(_amt=1):
	hp -= _amt
	get_parent().get_node("HUD/BossHP").set_hp(hp)
	if hp <= 0:
		die()
#1a->1b		
func player_on_carpet():
	set_physics_process(true)
	state = "talking"
	print("You will never get the tacos back, delivery girl! hahahaha!")
	#after dialogue timer, moves right
#instructs the boss to move to the second room
func move_to_room_2():
	move_by(Vector2(380, 0));

#when last thing destroyed
func die():
	print("AAAAA NOOOO. I WILL GET REVENGE") #dialogue
	state = "fly up"
	battle_started = false
	$Explosion.visible = true
	get_node("../Box").visible = true
	fly_up()
	print("you won")

	#then make the taco appear
#after death, flies up thru eiling
func fly_up():
	move_by(Vector2(0, -200))
	state = "moving"
	
func move_by(amt : Vector2):
	target_pos = position + amt
	state = "moving"
	print("movign")
	

	
func _physics_process(delta):
	if battle_started:
		var probability = delta * spawn_rate
		var rand = rng.randf_range(0.0, 1.0)
		if rand < probability:
			fire()
		new_pos_time -= delta
		if new_pos_time < 0:
			new_pos_time = 5.0
			new_pos()

	if state == "moving":
		if delta * tez_velocity > (target_pos - position).length():
			if battle_started:
				state = "waiting"
		position += tez_velocity * (target_pos - position).normalized() * delta
	elif state == "talking":
		print("stopping talking")
		state = "moving"
		move_to_room_2()
		
func new_pos():
	var x = rng.randf_range(new_pos_low_bounds.x, new_pos_hi_bounds.x)
	var y = rng.randf_range(new_pos_low_bounds.y, new_pos_hi_bounds.y)
	var new_pos = Vector2(x, y);
	move_by(new_pos - global_position)
	state = "moving"
		

#fires a bullet or appendage from tez
func fire():
	if (shoot_index+1)%3 == 0:
		spawn_tez()
	else:
		spawn_jay()
	shoot_index += 1

#fires an arm or head
func spawn_tez():
	var target = PlayerStats.get_player().position
	var part
	if missiles == 3: 
		part = $LeftArm
	elif  missiles == 2:
		part = $RightArm
	elif missiles == 1:
		part = $Head
	else:
		return
	part.enabled = true
	missiles -= 1
	part.target = PlayerStats.get_player()
	part.connect("destroyed", self, "take_damage")
	
	self.remove_child(part)
	get_parent().add_child(part)
	part.global_position = self.global_position

#fires a bullet at the player
func spawn_jay():
	var start = Vector2(rng.randi_range(0, spawn_range), 0)
	var target = Vector2(rng.randi_range(0, spawn_range), height)
	var motion = target - start
	motion *= jay_speed / motion.length()
	
	var enemy = jay.instance()
	get_parent().add_child(enemy)
	
	enemy.global_position = self.global_position
	enemy.motion = motion

#when the player enters the final area of the game, the battle begins
func entered_final_area(body):
	if body.is_in_group("Players"):
		if !battle_started:
			battle_started = true
			print("!!!")


func _on_destroy_arm():
	take_damage(1)
