extends Area2D

export(PackedScene) var target_scene
onready var door_sound = $door_sound
export var level = -1

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		if get_overlapping_bodies().size() > 0 and get_overlapping_bodies()[0].is_in_group("Players"):
			if !target_scene: # is null
				print("no scene in this door")
				return
			var player = get_overlapping_bodies()[0]
			if !player.is_in_group("Players"):
				return #not overlapping the door
			$AnimationPlayer.play("Open")
			door_sound.play()
			var body = get_overlapping_bodies()[0]
			var pos = body.get_global_transform_with_canvas().origin

			$circle_transition.door_transition(pos)
			get_overlapping_bodies()[0].play_walk_in_animation() #0 will be our player

func next_level():
	PlayerStats.level_beat = true
	var ERR = SaveSystem.change_scene_to(target_scene, level)
	
	if ERR != OK:
		print("something failed in the door scene")
		
