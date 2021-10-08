extends "res://art/breakable-items/jar/items/Coin.gd"


func _unique_function():
	PlayerStats.get_player().take_damage(-1)
