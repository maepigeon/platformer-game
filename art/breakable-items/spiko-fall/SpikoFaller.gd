extends "res://art/breakable-items/web/BreakablePlatform.gd"

export var groups_to_remove = ["Enemies"]
export var damage = 1

func kill_in_area():
	var enemies = $KillArea.get_overlapping_bodies()
	for enemy in enemies:
		for type in groups_to_remove: 
			if enemy.is_in_group(type):
				enemy.take_damage(damage)
	delete()
