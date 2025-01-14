extends KinematicBody2D
const ACCELERATION = 512
const MAX_SPEED = 92
const GROUND_POUND_SPEED = 144
const MAX_RUN_SPEED = 128
const AIR_RESISTANCE = 0.01
const GRAVITY = 1000
const JUMP_FORCE = 320
const WALK_FRICTION = 0.2
const CROUCH_FRICTION = 0.1
const CROUCH_SUPERCHARGE_TIME = .5 #crouch held for 1s and jump- jump high
const WALL_SLIDE_ACCELERATION = 256 
const MAX_WALL_SLIDE_SPEED = 92
const MAX_LADDER_SPEED = 42
const MAX_CARPET_SPEED = 128
const CARPET_ACCELERATION = 128
const CARPET_DECELERATION = 256
const CARPET_DEFAULT_MOTION = Vector2(16, 16)

var motion = Vector2.ZERO
var relative_x_speed = 0
var friction = WALK_FRICTION
var white_palette = [Color(0, 0, 0)]
var black_palette = [Color(0, 0, 0)]

export(PackedScene) var foot_step

signal grounded_updated(is_grounded)

var last_step = 0
var can_take_damage = true
var is_grounded #is the player grounded
onready var raycast = get_node("RayCast2D")
var platform_vol

var move_carpet_up_start_position


var carpet_on = null

var last_position = Vector2(0, 0)

#if player has control or not (useful for cutscene)
var has_control = true
var move_player = true

#if the player presses to jump while in the air 
#and holds when they hit ground, do a double jump
var early_jump = false
var can_jump = true
var early_jump_time = 0
var double_jump = 0
#but the player can't do this too early...
const MAX_EARLY_JUMP_TIME = 0.15


var crouch_charge_time = 0
var charged = false
var down_pressed = false

var input = Vector2.ZERO
var air_time = 0

var carpet_delta = Vector2.ZERO
var carpet_reference = null

onready var sprite = $AnimatedSprite
onready var color_swapper = $color_swapper

onready var jump_sound = $sounds/jump_sound
onready var land_sound = $sounds/land_sound
onready var footstep_sound_1 = $sounds/footstep_sound_1
onready var footstep_sound_2 = $sounds/footstep_sound_2
onready var death_sound = $sounds/death_sound
onready var takedamage_sound = $sounds/take_damage


var number_of_ladders_in = 0
var mode = "default"

func enter_ladder():
	number_of_ladders_in += 1
func exit_ladder():
	number_of_ladders_in -= 1
	if number_of_ladders_in == 0:
		mode = "default"
	
func _ready():
	PlayerStats.set_player(self)
	
func _physics_process(delta):
	if !has_control:
		return
		
	#handle our particles
	handle_player_particles(delta)
	
	var x_input = Input.get_action_strength("ui_right") - \
		Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_up") - \
		Input.get_action_strength("ui_down")
	var is_doing = Input.is_action_pressed("action") #jump action button
	if !has_control:
		x_input = 0
		y_input = 0
		
	input = Vector2(x_input, y_input)
	
	if number_of_ladders_in > 0 and y_input > 0:
			mode = "ladder"
	
	
	if mode == "ladder":
		handle_ladder_update(input)
	elif mode == "carpet":
		handle_carpet_update(input, is_doing, delta)
		
	elif mode == "default":	
		var is_crouching = Input.is_action_pressed("ui_down")
		var is_running = Input.is_action_pressed("run")
		if (!has_control):
			is_crouching = false
			is_running = false
			is_doing = false
		
			
		if x_input != 0:
			motion.x +=  x_input * ACCELERATION * delta
			if is_running:
				motion.x = clamp(motion.x, -MAX_RUN_SPEED, MAX_RUN_SPEED)
			else:
				motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
			sprite.flip_h = x_input < 0
		else:
			motion.x = lerp(motion.x, 0, friction)
		motion.y += GRAVITY * delta
		
		
		if !is_crouching:
			color_swapper.set_colors(color_swapper.palettes[0].get_colors())
			color_swapper.stop_loop()
			reset_charge()

		if is_on_floor():
			if crouch_charge_time >= CROUCH_SUPERCHARGE_TIME: 
				if !charged:
					random_dust(5, 5, 5)
					CameraEffects.shake(0.35)
					color_swapper.cycle_palette(.02, color_swapper.current_color_palette, .02, 0)
				charged = true
				early_jump_time = 0 #reset the early-jump time
			early_jump = false
			if is_crouching:
				crouch_charge_time += delta
			if Input.is_action_just_pressed("ui_down") && !charged:
				color_swapper._change_dynamic_speed(CROUCH_SUPERCHARGE_TIME)
				color_swapper.tween_between_color_palettes(color_swapper.palettes[0].get_colors(), color_swapper.palettes[1].get_colors())
		
		if is_on_floor():
			if x_input == 0:
				motion.x = lerp(motion.x, 0, friction)
			if Input.is_action_just_pressed("action") or \
				Input.is_action_pressed("action") and early_jump and \
				early_jump_time > 0 and early_jump_time < MAX_EARLY_JUMP_TIME:
				if crouch_charge_time >= CROUCH_SUPERCHARGE_TIME: 
					jump(1.4)
					CameraEffects.shake(0.35)
				else:
					jump(1.0)
				if raycast.is_colliding():
					platform_vol = raycast.get_collider()
					motion.x += (platform_vol.velocity.x * 70)
			
		else:
			crouch_charge_time = 0
			charged = false
			#handle wall jumps
			if is_on_wall():
				if Input.is_action_just_pressed("action") and Input.is_action_pressed("ui_right"):
					motion.x = -MAX_SPEED
					jump(1.0)
				elif Input.is_action_just_pressed("action") and Input.is_action_pressed("ui_left"):
					motion.x = MAX_SPEED
					jump(1.0)
				
			# handle jumping	
			if Input.is_action_just_released("action") and motion.y < -JUMP_FORCE / 2:
				motion.y = -JUMP_FORCE / 2
			if Input.is_action_just_released("action"):
				early_jump = false
				early_jump_time = 0
			if Input.is_action_just_pressed("action"):
				early_jump = true
			elif Input.is_action_pressed("action"):
				early_jump_time += delta 
			if x_input == 0:
				motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
			if  Input.is_action_just_pressed("ui_down"): #ground pound
				motion.y = JUMP_FORCE
				motion.x = 0
				mode = "ground_pounding"
		if is_crouching:		
			sprite.play("crouch")
			friction = CROUCH_FRICTION
			motion.x = 0
		elif x_input != 0:
			sprite.play("walk")
		else:
			sprite.play("default")
		if Input.is_action_just_released("ui_down"):
			reset_charge()
	elif mode == "ground_pounding":
		if is_on_floor():
			mode = "default" # end ground pound
	
	# calculate air time and handle landing
	if !is_on_floor() and !is_on_wall():
		air_time += delta
	else:
		if air_time > .5:
			land_sound.play()
		air_time = 0
		
	var was_grounded = is_grounded
	is_grounded = is_on_floor() or air_time < 0.07
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_updated", is_grounded)
	
	# apply the physics	
	last_position = position
	motion = move_and_slide(motion, Vector2.UP)
	
# initiates a jump (causes the player to jump. The strength of the jump is
# dependent on the force multiplier)
func jump(force_multiplier):
	motion.y = -JUMP_FORCE * force_multiplier
	jump_sound.play()

func reset_charge():
	crouch_charge_time = 0
	charged = false
	
	
func handle_carpet_move_update(delta):
	var top_position = Vector2(position.x, -20)
	position = position.move_toward(top_position, MAX_RUN_SPEED * delta)
	if abs(position.y + 20) < 1:
		mode = "carpet"
	
		
# handles the movement logic between frame updates when the player is on a magic
# carpet
func handle_carpet_update(input, is_jumping, delta):
	var carpet = carpet_on
	motion += Vector2(input.x, -input.y) * CARPET_ACCELERATION * delta
	
	sprite.flip_h = input.x < 0
	
	if input.x == 0 and motion.x != 0:
		var orig_direction =get_sign(motion.x)
		motion -= Vector2(motion.x / abs(motion.x) * CARPET_DECELERATION * delta, 0)
		if get_sign(motion.x) != orig_direction:
			motion.x = 0
			
	if input.y == 0 and motion.y != 0:
		var orig_direction =get_sign(motion.y)
		motion -= Vector2(0, motion.y / abs(motion.y) * CARPET_DECELERATION * delta)
		if get_sign(motion.y) != orig_direction:
			motion.y = 0
		
	if motion.length() > MAX_CARPET_SPEED:
		motion = motion.normalized() * MAX_CARPET_SPEED
		
	if (abs(carpet_delta.x - (global_position.x - carpet_reference.global_position.x)) > 5 or
		abs(carpet_delta.y - (global_position.y - carpet_reference.global_position.y)) > 5):
		carpet_reference.global_position = global_position - carpet_delta
		
	if is_jumping:
		set_mode_carpet(null)
		jump(1.0)
		return

#return true if the number is positive or zero if negative
func get_sign(number):
	return number > 0
	 
# handles the movement logic when the player is climbing a ladder
func handle_ladder_update(input):
	motion = Vector2(input.x, -input.y)
	motion = motion.normalized() * MAX_LADDER_SPEED
	if motion.x == 0 and motion.y == 0:
		sprite.play("climbing_idle")
	else:
		sprite.play("climbing")
	if is_on_floor():
		mode = "default"
	
# hurts the player
func take_damage(damage=1):
	if can_take_damage:
		can_take_damage = false
		print("taking damage")
		color_swapper.set_colors(white_palette)
		color_swapper.cycle_palettes(.2, [black_palette, white_palette], .1, 3)
		PlayerStats.take_damage(damage)
		CameraEffects.shake(.6)
		if (damage > 0):
			takedamage_sound.play()
		if PlayerStats.hp < 1:
			game_over()
		yield(get_tree().create_timer(1), "timeout")
		can_take_damage = true
		
		
func handle_player_footstep_sound():
	if (sprite.animation == "walk" and is_on_floor()):
		if sprite.frame == 0:
			footstep_sound_1.play()
		elif sprite.frame == 2:
			footstep_sound_2.play()

func random_dust(_direction, spread, amount):
	for index in range(amount):
		var footstep = foot_step.instance()
		footstep.emitting = true
		footstep.global_position = Vector2(global_position.x, \
				 	global_position.y + 5)
		footstep.vel = (Vector2(10,-30))
		get_parent().add_child(footstep)

#the carpet object can be null or not
func set_mode_carpet(carpet_object):
	if carpet_object != null:
		mode = "carpet"
		var c_pos = carpet_object.global_position
		carpet_object.get_parent().remove_child(carpet_object)
		add_child(carpet_object)
		carpet_object.global_position = c_pos
		carpet_delta = global_position - c_pos

	else:
		mode = "default"
		var c_pos = carpet_on.global_position
		remove_child(carpet_on)
		get_parent().add_child(carpet_on)
		carpet_on.global_position = c_pos
	carpet_reference = carpet_object
	carpet_on = carpet_object
	
func handle_player_particles(delta):
	if (motion.x == 0):
		last_step = -1
	if (sprite.animation == "walk" and is_on_wall() or is_on_floor()):
		if (sprite.frame == 0 or sprite.frame == 2 or Input.is_action_pressed("run")):
			if (last_step != sprite.frame):
				handle_player_footstep_sound()
				last_step = sprite.frame
				var footstep = foot_step.instance()
				footstep.emitting = true
				footstep.global_position = Vector2(global_position.x, \
				 	global_position.y + 5)
				footstep.vel = (last_position - position) / delta
				get_parent().add_child(footstep)

# pause the world and do animations for walking into a door	
func play_walk_in_animation():
	mode = "entering"
	can_take_damage = false
	motion.x = 0
	sprite.play("enter_door")
	for x in range(5):
		footstep_sound_1.play()
		yield(get_tree().create_timer(0.15), "timeout")

# obtained an item - pick it up and show it to screen, like a taco or something
func play_got_item_animation():
	sprite.play("got_item")

# you ran out of hp, and die. Need to restart the level.
func game_over():
	death_sound.play()
	PlayerStats.set_respawn(true)
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().reload_current_scene()
