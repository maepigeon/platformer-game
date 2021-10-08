extends "res://art/breakable-items/jar/items/Coin.gd"

signal got_taco()

func unique_function():
	emit_signal("got_taco")
