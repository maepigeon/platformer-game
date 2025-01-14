extends "res://art/ui/BigCoin.gd"


func _unique_function():
	get_parent().get_parent().get_node("StuffThatAppears2").visible = true
	PlayerStats.add_coin(coinIndex)
