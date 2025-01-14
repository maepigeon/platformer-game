extends Node

var camera

var xTile_translation = 176

export var camera_shifting_enabled = true #whether the camera shifts when the player moves


func shake(amount):
	if camera != null:
		camera.add_trauma(amount)
	else:
		print("warning: camera not set on cameraeffects")
	
func left_transition():
	if camera_shifting_enabled:
		camera.position.x -= xTile_translation
func right_transition():
	if camera_shifting_enabled:
		camera.position.x += xTile_translation

func set_y(y_pos):
	camera.position.y = y_pos

func crush_web_sound():
	$WebSound.play()

# sets the node that the camera will follow
func set_follow_node(_target):
	if camera.target_object != null and camera.target_object.is_in_group("CameraFixers"):
		camera.target_object.return_to_parent()
	camera.target_object = _target

