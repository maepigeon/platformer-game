extends "../state.gd"

var at_target = true
var speed = 64
var landed = false
	

func enter():
	owner.motion.y = -148
	owner.motion.x = 64 * owner.direction
	print("direction: " + str(owner.direction))
	landed = false
	
func update(_delta):
	var diff = owner.global_position.x - \
		(owner.get_node_at_position(owner.anticipated_position).position.x)
		
	if landed or (owner.direction < 0 and diff < -0.1 or owner.direction > 0 and diff > 0.1):
		_on_animation_finished("jump")
		
	if !landed and owner.is_on_floor():
		landed = true
		CameraEffects.shake(0.6)
		
	

func _on_animation_finished(_name):
	owner.current_position = owner.anticipated_position
	owner.motion.x = 0
	emit_signal("finished", "jump")
