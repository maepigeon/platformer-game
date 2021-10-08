extends RayCast2D

signal hit_player

var cast_to_player = false


var is_casting = false setget set_is_casting
var x = Vector2.ZERO
var largest_x = Vector2.ZERO
var returning = true	#
var attack_mode = false # whether the frog is in attack_mode or suck_mode
var took_hit = false

func set_is_casting(casting: bool):
	is_casting = casting
	set_physics_process(is_casting)
	
func enable_physics_process():
	set_physics_process(true)

func _ready():
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO
	
	
func _physics_process(_delta):
	if cast_to_player:
		var cast_point : = cast_to
		force_raycast_update()
		if is_casting and is_colliding():
			cast_point = to_local(get_collision_point())
			appear(cast_point)
			largest_x = x
		elif returning:
			disappear(largest_x)
			returning = false
		$Line2D.points[1] = x
	else:
		cast_to = x #the point where the raycast that detects the player is cast to
		var body = get_collider()
		if is_casting and is_colliding() and body.is_in_group("Players"):
			if body.mode == "ground_pounding":
				take_hit()
			elif !get_parent().took_damage:
				emit_signal("hit_player")
		var cast_point = cast_to
		force_raycast_update()
		if is_casting and is_colliding():
			appear(cast_point)
			largest_x = x
		elif returning:
			disappear(largest_x)
			returning = false
		$Line2D.points[1] = x
		
func cast_to(local_position : Vector2, speed : float):
	set_is_casting(true)
	get_node(@"../anim").play("open_mouth")
	yield(get_tree().create_timer(0.75), "timeout")
	largest_x = local_position
	$Tween.stop_all()
	$Tween.interpolate_property(self, "x", Vector2.ZERO, local_position, 0.8, Tween.TRANS_LINEAR)
	$Tween.start()
	yield(get_tree().create_timer(local_position.length() / speed), "timeout")
	returning = true
	
func take_hit():
	if !took_hit:
		get_parent().take_damage(1)
		took_hit =true
	pause()

func pause():
	print("paused tongue async")
	#async callback to when unpause
	#start retracting now
	
func appear(position):
	$Tween.stop_all()
	interpolate_to(position)
	$Tween.start()
	
func disappear(largestx):
	print(x)
	$Tween.stop_all()
	$Tween.interpolate_property(self, "x", largestx, Vector2.ZERO, 0.5, Tween.TRANS_LINEAR)
	$Tween.start()
	$Tween.start()

func interpolate_to(y):
	$Tween.interpolate_property(self, "x", null, y, 0.5, Tween.TRANS_LINEAR)
	$Tween.start()
