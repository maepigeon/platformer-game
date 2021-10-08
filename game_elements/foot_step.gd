extends Particles2D
var parent
var vel

func _ready():
	yield(get_tree().create_timer(1),"timeout")
	queue_free()
	
func _process(delta):
	position += vel * delta / 10
