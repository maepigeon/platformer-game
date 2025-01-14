extends KinematicBody2D


export var boss_scene = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("Players"):
		body.set_mode_carpet(self)
		$CollisionShape2D.disabled = false
		if boss_scene:
			boss_scene = false
			get_node("../../Tez").player_on_carpet()

	
func fix_child():
	$platform.position = Vector2.ZERO

# called from the player when the player jumps
#unmounts the player
func on_jump(player):
	player.set_mode_carpet(null)
	$CollisionShape2D.disabled = true

