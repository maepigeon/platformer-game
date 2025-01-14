extends "res://worlds/World.gd"

func _ready():
	start_battle()

func start_battle():
	$SceneAnimations.play("SlideDoorDown")
	free_rest_of_world()
func free_rest_of_world():
	if get_node_or_null("bomb") != null:
		$bomb.queue_free()
