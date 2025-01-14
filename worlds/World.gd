extends Node2D


const OFFSET_RIGHT = 12
const OFFSET_LEFT = -12
var started = false
var optionsMenu
var hp = 1

func _on_Area2D_body_entered(body):
	if body.is_in_group("moving_objects"):
		body.set_position(Vector2( $Area2D2.position.x + OFFSET_LEFT, $Player.position.y - 5))

func _on_Area2D2_body_entered(body):
	if body.is_in_group("moving_objects"):
		body.set_position(Vector2( $Area2D.position.x + OFFSET_RIGHT, $Player.position.y - 5))

func _ready():
	optionsMenu = $HUD/OptionsMenu
	optionsMenu.swapbuttonicon("restart", "quit")
	started = true
	PlayerStats.initialize_HUD()
	
func _level_clear():
	$HUD.level_cleared()
	
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		optionsMenu.visible = true
		optionsMenu.enabled = true
		optionsMenu.just_started = true
		optionsMenu.display = "game"
		optionsMenu.show_button("return", 2)
		get_tree().paused = true 
