extends StaticBody2D

export var spawn_point_offset = Vector2(0,0)
export (PackedScene) var start_scene
export var spawn_time = 1.0
export var offset_time = 0 #time before it starts doing its thing at first
export var spawing_enabled = true
export (bool) var loop_on_start = true
export var direction = -1
export var destroy_enemy_after_time = -1 # if negative, the enemies stay
export var max_amt_spawned = -1 # if -1, infinite amount

var spawned_references

var glow_time = 0.6

var enemy_count = 0

func _ready():
	if !spawing_enabled:
		$Timer.one_shot =true
		return
	yield(get_tree().create_timer(offset_time),"timeout")
	if loop_on_start == true:
		_on_Timer_timeout()
	$Timer.set_wait_time(spawn_time)
	$Timer.start()	
	
func do_glow_animation():
	$AnimationPlayer.play("Glow")


func _on_Timer_timeout():
	if max_amt_spawned < 0 or enemy_count < max_amt_spawned:
		do_glow_animation()
		yield(get_tree().create_timer(glow_time), "timeout")

		var enemy = start_scene.instance()
		enemy_count += 1
		get_node("../").add_child(enemy)
		enemy.position = position + spawn_point_offset
		if "direction" in enemy:
			enemy.direction = direction
		if destroy_enemy_after_time > 0:
			yield(get_tree().create_timer(destroy_enemy_after_time),"timeout")
			enemy.take_damage(1)
			enemy_count -= 1
		
#Note: not yet used anywhere.
func remove_enemy():
	enemy_count -= 1
