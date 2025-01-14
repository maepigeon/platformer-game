# this is a node that clamps the camera's position in a certain range
# while still following the player
extends Node2D

export var enabled = false
export var min_pos = Vector2.ZERO
export var max_pos = Vector2.ZERO
export var target : NodePath setget set_target
var target_node
onready var original_parent = get_parent()

func _ready():
	set_target(target)


func enabled(_enabled, _body):
	target_node = _body
		
	enabled = _enabled
	set_physics_process(_enabled)
	if _enabled:
		CameraEffects.set_follow_node(self)
	

func set_target(_target):
	target = _target
	target_node = get_node(_target)
	
func _physics_process(delta):
	position = Vector2( \
		clamp(target_node.position.x, min_pos.x, max_pos.x), \
		clamp(target_node.position.y, min_pos.y, max_pos.y) \
	)
	
func return_to_parent():
	get_parent().remove_child(self)
	original_parent.add_child(self)


func _on_CameraFixerChanger_body_entered(body):
	if body.is_in_group("Players"):
		enabled(true, body)


