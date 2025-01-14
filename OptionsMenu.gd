extends Node2D

signal enable_menu

var return1 = Vector2(55, 17)
var return2 = Vector2(107, 34)
var volume1 = Vector2(58, 55)
var volume2 = Vector2(102, 64)
var music1 = Vector2(57, 45)
var music2 = Vector2(103, 55)
var save1 = Vector2(58, 80)
var save2 = Vector2(103, 88)
var load1 = Vector2(58, 90)
var load2 = Vector2(103, 98)
var restart1 = Vector2(73, 105)
var restart2 = Vector2(103, 112)
var fullscreen1 = Vector2(57, 102)
var fullscreen2 = Vector2(68, 114)

onready var button_sound = $button_sound

var music_muted = false
var volume_muted = false
var button_clicked = "none"
var do_callback = false

var display = "mainmenu"

var mode = "cursor"
var button_order = ["return", "music", "volume", "fullscreen", "restart"]
var button_index = 0

var enabled = false
var just_started = true

func _process(_delta):
	if enabled:
		if Input.is_action_just_pressed("escape") and !just_started:
			call_button_function("return")
			return
			
		if Input.is_action_just_pressed("ui_down"):
			mode = "buttons"
			button_iterate(1)
		if Input.is_action_just_pressed("ui_up"):
			mode = "buttons"
			button_iterate(-1)
		if Input.is_action_just_pressed("action"):
			if !just_started:
				call_button_function(button_order[button_index])
			click_button(button_order[button_index])
		just_started = false
		if Input.is_action_just_released("action"):
			show_button(button_order[button_index], 2)

func _input(ev):
	if enabled:
		if ev is InputEventMouseButton:
			mode = "cursor"
			if is_in_button(ev, return1, return2):
				click_button_event("return")
			elif is_in_button(ev, music1, music2):
				click_button_event("music")
			elif is_in_button(ev, volume1, volume2):
				click_button_event("volume")
#			elif is_in_button(ev, save1, save2):
#				click_button_event("save")
#			elif is_in_button(ev, load1, load2):
#				click_button_event("load")
			elif is_in_button(ev, restart1, restart2):
				click_button_event("restart")
			elif is_in_button(ev, fullscreen1, fullscreen2):
				click_button_event("fullscreen")
			else:
				button_clicked = "none"	
		if ev is InputEventMouseMotion:
			mode = "cursor"
			hover_button_event("return", ev, return1, return2)
			hover_button_event("music", ev, music1, music2)
			hover_button_event("volume", ev, volume1, volume2)
#			hover_button_event("save", ev, save1, save2)
#			hover_button_event("load", ev, load1, load2)
			hover_button_event("restart", ev, restart1, restart2)
			hover_button_event("fullscreen", ev, fullscreen1, fullscreen2)

func is_in_button(ev, pos1, pos2):
	return ev.position.x > pos1.x and ev.position.x < pos2.x and \
			ev.position.y > pos1.y and ev.position.y < pos2.y
			
func click_button_event(button_name):
	click_button(button_name)
	if do_callback:
		do_callback = false
		call_button_function(button_name)
func hover_button_event(button_name, event, pos1, pos2):
	if is_in_button(event, pos1, pos2):
		if button_clicked != button_name:
			hover_button(button_name)
		else:
			show_button(button_name, 3)
	else:
		show_button(button_name, 1)

func button_iterate(delta):
	if delta + button_index >= 0 and delta + button_index < len(button_order):
		show_button(button_order[button_index], 1)
		button_index += delta
		show_button(button_order[button_index], 2)

func click_button(button_name):
	button_sound.play()
	if button_clicked == button_name and mode != "buttons":
		show_button(button_name, 2)
		button_clicked = "none"
		do_callback = true
		return
	elif button_clicked == "none" or mode == "buttons":
		button_clicked = button_name
		show_button(button_name, 3)
		return
	else:
		button_clicked = "none"
		
func call_button_function(button_name):
	if button_name == "return":
		visible = false
		enabled = false
		just_started = true
		if display == "game":
			get_tree().paused = false
		else:
			emit_signal("enable_menu")
	elif button_name == "music":
		swapbuttonicon("music", "music_deselect")
		music_muted = !music_muted
		AudioServer.set_bus_mute(1, music_muted)
	elif button_name == "volume":
		swapbuttonicon("volume", "volume_deselect")
		volume_muted = !volume_muted
		AudioServer.set_bus_mute(2, volume_muted)
	elif button_name == "play":
		print(button_name)
	elif button_name == "restart":
		if display == "mainmenu":
			print(button_name)
			get_parent().toggle_reset()
		else:
			get_tree().paused = false
			SaveSystem.change_scene("res://MainMenu.tscn", -1)
			print("quitting game")
#	elif button_name == "save":
#		print(button_name)
#	elif button_name == "load":
#		print(button_name)
	elif button_name == "fullscreen" or button_name == "minimize":
		swapbuttonicon("fullscreen", "minimize")
		OS.window_fullscreen = !OS.window_fullscreen
	return
		
func hover_button(button_name):
	if button_name != button_clicked:
		show_button(button_name, 2)
		
func swapbuttonicon(button1, button2):
	var temp = get_node(button1).texture
	var temp_clicked = get_node(button1+"_hover").texture
	var temp_hover = get_node(button1+"_clicked").texture
	get_node(button1).set_texture(get_node(button2).texture)
	get_node(button1+"_hover").set_texture(get_node(button2+"_hover").texture)
	get_node(button1+"_clicked").set_texture(get_node(button2+"_clicked").texture)
	get_node(button2).set_texture(temp)
	get_node(button2+"_hover").set_texture(temp_clicked)
	get_node(button2+"_clicked").set_texture(temp_hover)
	

func show_button(button, index):
	var base = get_node(button)
	var hover = get_node(button+"_hover")
	var clicked = get_node(button+"_clicked")
	base.visible = index == 1
	hover.visible = index == 2
	clicked.visible = index == 3

