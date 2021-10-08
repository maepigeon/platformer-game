extends "res://art/breakable-items/jar/items/Coin.gd"

export var coinIndex = 0

func _unique_function():
	PlayerStats.add_coin(coinIndex)
