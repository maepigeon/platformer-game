extends ParallaxBackground

var player

func _init():
	player = PlayerStats.get_player()

func move():
	var scroll = Vector2(0,3) #Some default scrolling so there's always movement.
	if player != null:
		scroll += player.velocity
	$ParallaxBackground.scroll_offset += scroll
