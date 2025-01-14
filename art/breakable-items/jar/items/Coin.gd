extends Area2D

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
export var points = 500

var gone = false
func _on_body_entered(body):
	if !gone:
		anim_player.play("fade_out")
		gone = true
		$coin_sound.play()
		PlayerStats.increase_score(points)
	_unique_function()

func _unique_function():
	pass
