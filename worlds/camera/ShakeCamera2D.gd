extends Camera2D

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 50)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
export (NodePath) var target  # Assign the node this camera will follow.
var target_object : Node2D

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
onready var noise = OpenSimplexNoise.new()
var noise_y = 0

onready var prev_camera_pos = get_camera_position()
onready var tween = $ShiftTween
var facing = 0
const LOOK_AHEAD_FACTOR = 0.2
const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 1.0

var y_platform_snapping = false

func _ready():
	target_object = get_node(target)
	
	if target_object:
		yield(get_parent(), "ready")
		get_parent().remove_child(self)
		target_object.add_child(self)
		position = Vector2(0, 0)
		print("reparenting")
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	current = true
	CameraEffects.set("camera", self)

func _process(delta):
	if target_object:
		global_position = target_object.global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
		
	check_facing()
	prev_camera_pos = get_camera_position()
	
func check_facing():
	var new_facing = sign(get_camera_position().x - prev_camera_pos.x)
	if new_facing != 0 && facing != new_facing:
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * facing
		
		tween.interpolate_property(self, "position:x", position.x, target_offset, \
			SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
		tween.start()
		
func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	# Using noise
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
	
func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
	


func _on_Player_grounded_updated(is_grounded):
	if y_platform_snapping:
		drag_margin_v_enabled = !is_grounded
