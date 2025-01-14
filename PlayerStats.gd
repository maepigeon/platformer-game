extends Node

var score = 0
var big_coins = [false, false, false]
var world = -1
var HUD
var player_reference
var level_beat = true
var hp = 2
var respawn = false #indicates whether the player jus respawned


func initialize_HUD():
	if respawn:
		respawn()
	if HUD:
		HUD.update_bigcoins(big_coins)
	set_score(score)
	set_hp(hp)
	
	
func respawn():
	set_hp(2)
	print("respawning")
	set_respawn(false)
	

func get_score():
	return score

func set_player(player):
	player_reference = player
func get_player():
	return player_reference

func take_damage(amt):
	hp -= amt
	set_hp(hp)

func increase_score(amount):
	set_score(score + amount)
	
func set_score(amt):
	score = amt
	if HUD:
		HUD.update_score(amt)

func set_hp(_hp):
	hp = _hp
	if HUD:
		HUD.update_hp(_hp)
	else:
		print("need HUD")
		
func update_coins():
	HUD.update_bigcoins(big_coins)

func set_respawn(value):
	respawn = value
	
	
func add_coin(coin_index, clap=true):
	big_coins[coin_index] = true
	if clap and big_coins[1] and big_coins[2] and big_coins[0]:
		get_tree().get_current_scene().get_node("Applause").play()

	update_coins()
