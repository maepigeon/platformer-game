extends Sprite

var cleared = false
var closed = false
func level_clear():
	visible = true
	cleared = true
	
func close():
	pass
	
func _input(event):
	if cleared and event.is_action_pressed("action"):
		closed =true
		close()
