extends Node2D

const SAVE_DIR = "user://saves/"
var save_path = SAVE_DIR + "save.dat"


func save_game(level_to_update):
	
	var old_game_data = [get_level_data(1, false), get_level_data(2, false), get_level_data(3, false)]
	
	
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(str(PlayerStats.get_score()))
	
	
	#create the data to update in the file
	
	var level_data = "T"
	var index = 1
	for i in PlayerStats.big_coins:
		level_data += bool_to_str(i or str_to_bool((old_game_data[level_to_update - 1])[index]))
		index += 1
	
	#save the specific level
	print("saving level "+str(level_to_update)+". str: "+str(level_data))
	if level_to_update > 0:
		for i in range(level_to_update - 1):
			if not save_game.eof_reached():
				save_game.store_line(old_game_data[i])
			else:
				save_game.store_line("FFFF")
		save_game.store_line(level_data)
		print(level_data)
	else:
		print("Invalid level number!")
	save_game.close()
	
func bool_to_str(bool_data):
	if bool_data == false:
		return "F"
	return "T"
	
func str_to_bool(str_data):
	if str_data == "T":
		return true
	return false
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	var line_data = str(save_game.get_line())
	print(line_data)
	PlayerStats.set_score(int(line_data))
	save_game.close()
	PlayerStats.initialize_HUD()
	
func get_level_data(level_index, should_use_data = true):
	var level_data = "FFFF"
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		print("save not found!")
		return level_data # Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	var line_counter = 1
	for i in range(level_index+1):
		level_data = save_game.get_line()
		if save_game.eof_reached() and i != level_index:
			level_data = "FFFF"
			print("end of file")
			
	print("level data: " + str(level_data))
	if len(level_data) != 4:
		print("invalid data")
		level_data = "FFFF"
	
	if should_use_data:
		set_level_data(level_data)
	
	save_game.close()
	return level_data
	
func set_level_data(level_data):
	#use the data
	PlayerStats.level_beat = str_to_bool(level_data[0])
	PlayerStats.big_coins[0] = str_to_bool(level_data[1])
	PlayerStats.big_coins[1] = str_to_bool(level_data[2])
	PlayerStats.big_coins[2] = str_to_bool(level_data[3])
	PlayerStats.update_coins()
	
	
func reset_game():
	var dir = Directory.new()
	PlayerStats.set_score(0)
	dir.remove("user://savegame.save")
	get_tree().get_nodes_in_group("MainMenu")[0].change_level_1()
	PlayerStats.hp = 0
	PlayerStats.initialize_HUD()
	load_game()
	
	
func change_scene(next_scene, level_to_update):
	if level_to_update != -1:
		save_game(level_to_update)
	get_tree().change_scene(next_scene)
	PlayerStats.initialize_HUD()
func change_scene_to(next_scene, level_to_update):
	if level_to_update != -1:
		save_game(level_to_update)
	get_tree().change_scene_to(next_scene)
	PlayerStats.initialize_HUD()
