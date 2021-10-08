extends Node2D
# If thn player is above v_trigger_line, then the camera will be offset
# by v_offset.


export var v_trigger_line : float = 0
export var v_offset : float = 0

var original_y : float

func _ready():
	original_y = CameraEffects.get_camera_pos().y

func _physics_process(delta):
	if PlayerStats.get_player().position.y < v_trigger_line:
		CameraEffects.set_y(original_y - v_offset)
	else:
		CameraEffects.set_y(original_y)
