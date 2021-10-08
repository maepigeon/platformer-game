extends Node2D

export var coins = 20
export var end_time = 3
export var spawn_range = Vector2(160, -24) 
export var gravity_coin : PackedScene
var cur_time = 0

func _ready():
	set_physics_process(false)

func drop_coins():
	set_physics_process(true)
	
func _physics_process(delta):
	if cur_time > end_time:
		set_physics_process(false)
	cur_time += delta
	var probability = delta * coins / end_time
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand = rng.randf_range(0.0, 1.0)
	if rand < probability:
		var x = rng.randi_range(0, spawn_range.x)
		var y = rng.randi_range(0, spawn_range.y)
		var coin = gravity_coin.instance()
		add_child(coin)
		coin.position = Vector2(x, y)
