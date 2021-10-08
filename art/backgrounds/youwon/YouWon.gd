extends Control

func _physics_process(delta):
	SaveSystem.load_game()
	$Label.text = str(PlayerStats.score)
	
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			get_tree().change_scene("res://MainMenu.tscn")
