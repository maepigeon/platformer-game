extends KinematicBody2D

signal state_changed
signal kill

onready var states_map = {
	"start_sequence_battle" : $States/StartSequenceBattle,
	"start_sequence_start" : $States/StartSequenceStart,
	"angry_face" : $States/AngryFace,
	"anticipate" : $States/Anticipate,
	"jump" : $States/Jump,
	"taking_damage" : $States/TakingDamage,
	"dying" : $States/Dying, 
	"tongue_attack" : $States/TongueAttack,
	"devour_player" : $States/DevourPlayer
}
export var positions = {0 : "../HPlatform", 1: "../HPlatform2", 2 : "../HPlatform3"}
var anticipated_action = "tongue_attack"
var anticipated_position = 0

var took_damage = false #whether the frog has taken damage on this turn

var states_stack = []
var current_state = null
var current_position = 2
var hp = 3
var direction = -1

var wait_time = 0
var initial_player_pos = null
var final_player_pos = position
export var next_scene : PackedScene
export var boss_mode = true
export var hostile = true

var iteration = 0

var GRAVITY = 128
var speed = 32
var motion = Vector2.ZERO

func _ready():
	if boss_mode:
		boss_mode_ready()
	
func boss_mode_ready():
	for state_node in $States.get_children():
		state_node.connect("finished", self, "_change_state")
		
	states_stack.push_front($States/Jump)
	states_stack.push_front($States/Anticipate)
	states_stack.push_front($States/AngryFace)
	states_stack.push_front($States/StartSequenceBattle)
	current_state = states_stack[0]
	_change_state("start_sequence_battle")
	
func get_node_at_position(_position):
	return get_node(positions[_position])
	
func _physics_process(delta):
	motion.y += GRAVITY * delta
	motion = move_and_slide(motion, Vector2.UP)
		
	current_state.update(delta)
	
func face_position(pos):
	$anim.flip_h = pos.x < position.x
	
func random_valid_position():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(0, 2)
	var x = num if num != current_position else random_valid_position()
	return x


func _change_state(state_name):
	"""
	We use this method to:
		1. Clean up the current state with its the exit method
		2. Manage the flow and the history of states
		3. Initialize the new state with its enter method
	Note that to go back to the previous state in the states history,
	the state objects return the "previous" keyword and not a specific
	state name.
	"""
	current_state.exit()
	
	took_damage = false
	
	if state_name == "previous":
		states_stack.pop_front()
		print("state popped from stack")
	elif state_name in ["start_sequence_battle", "jump", "tongue_attack"]:
		states_stack.pop_front()
		states_stack.push_front(states_map["angry_face"])
	elif state_name == "angry_face":
		states_stack.pop_front()
		states_stack.push_front(states_map["anticipate"])
		iteration += 1
	elif state_name == "anticipate":
		states_stack.pop_front()
		states_stack.push_front(states_map[anticipated_action])
	elif state_name == "devour_player":
		print("devouring player")
		get_tree().reload_current_scene()
	elif state_name == "start_sequence_start":
		states_stack.pop_front()
		states_stack.push_front(states_map["devouring_player"])
	elif state_name == "dying":
		print("froggo dying")
		queue_free()
	else:
		var new_state = states_map[state_name]
		states_stack[0] = new_state

		
	current_state = states_stack[0]
	
	if state_name != "previous":
		# We don't want to reinitialize the state if we're going back to the previous state
		current_state.enter()
	emit_signal("state_changed", states_stack)
	

func _eat_player():
	$Tongue.set_is_casting(true)
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
	
	
func take_damage(amt):
	took_damage = true
	do_glow_animation()
	hp -= amt
	get_parent().get_node("BossHP").set_hp(hp)
	print("monsieur froggo took damage "+str(amt)+" new hp: "+str(hp))
	if hp <= 0:
		kill()
		
func do_glow_animation():
	$AnimationPlayer.play("Glow")

func kill():
	_change_state("dying")
	$anim.visible = false
	$Particles2D.visible = true
	show_door()
	emit_signal("kill")
	print("monsieur froggo dying")

func show_door():
	get_parent().get_node("Box").visible = true
	get_parent().get_node("Box").position = Vector2(120, 92)
	
func face_direction(_direction):
	direction = _direction / abs(_direction)
	$anim.set_flip_h(direction > 0)
	


func _on_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)


# player touched froggo and they are now taking damage
func _on_Area2D_body_entered(body):
	if body.is_in_group("Players") and hostile:
		body.take_damage(1)

#hit player and the player takes damage
func _on_Tongue_hit_player():
	PlayerStats.get_player().take_damage(1)

