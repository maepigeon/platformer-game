extends MarginContainer
var play1 = Vector2(49, 40)
var play2 = Vector2(112, 69)
var left1 = Vector2(53, 72)
var left2 = Vector2(65, 84)
var right1 = Vector2(96, 72)
var right2 = Vector2(108, 84)
var options1 = Vector2(55, 103)
var options2 = Vector2(105, 113)

onready var button_sound = $button_sound


onready var levels = [$level_1, $level_2, $level_3]

var level_count = 3
var selected_level = 1
var button_clicked = "none"
var do_callback = false

var enabled = false

var mode = "cursor"
var button_order = ["play", "right", "options"]
var button_index = 0 setget set_button_index


func _process(_delta):
	if enabled:
		if Input.is_action_just_pressed("ui_left") and button_index == 1:
			button_order[1] = "left"
			show_button("right", 1)
			show_button("left", 2)
		if Input.is_action_just_pressed("ui_right") and button_index == 1:
			button_order[1] = "right"
			show_button("left", 1)
			show_button("right", 2)
		if Input.is_action_just_pressed("ui_down"):
			mode = "buttons"
			button_iterate(1)
		if Input.is_action_just_pressed("ui_up"):
			mode = "buttons"
			button_iterate(-1)
		if Input.is_action_just_pressed("action"):
			call_button_function(button_order[button_index])
			click_button(button_order[button_index])
		if Input.is_action_just_released("action"):
			show_button(button_order[button_index], 2)


func toggle_reset():
	$Control.visible = !$Control.visible
	
func reset():
	SaveSystem.reset_game()
	toggle_reset()
	
	$OptionsMenu.visible = false
	$OptionsMenu.enabled = false
	enabled = true


func _input(ev):	
	if enabled:
		if ev is InputEventMouseButton:
			mode = "cursor"
			if is_in_button(ev, play1, play2):
				click_button("play")
				if do_callback:
					do_callback = false
					call_button_function("play")
			elif is_in_button(ev, left1, left2):
				click_button("left")
				if do_callback:
					do_callback = false
					call_button_function("left")
			elif is_in_button(ev, right1, right2):
				click_button("right")
				if do_callback:
					do_callback = false
					call_button_function("right")
			elif is_in_button(ev, options1, options2):
				click_button("options")
				if do_callback:
					do_callback = false
					call_button_function("options")
			else:
				button_clicked = "none"
		if ev is InputEventMouseMotion:
			mode = "cursor"
			if is_in_button(ev, play1, play2):
				if button_clicked != "play":
					hover_button("play")
				else:
					show_button("play", 3)
			else:
				show_button("play", 1)
			if is_in_button(ev, left1, left2):
				if button_clicked != "left":
					hover_button("left")
				else:
					show_button("left", 3)
			else:
				show_button("left", 1)
			if is_in_button(ev, right1, right2):
				if button_clicked != "right":
					hover_button("right")
				else:
					show_button("right", 3)
			else:
				show_button("right", 1)

			if is_in_button(ev, options1, options2):
				if button_clicked != "options":
					hover_button("options")
				else:
					show_button("options", 3)
			else:
				show_button("options", 1)


func set_button_index(index):
	show_button(button_order[button_index], 1)
	button_index = index
	show_button(button_order[button_index], 2)
	

func is_in_button(ev, pos1, pos2):
	return ev.position.x > pos1.x and ev.position.x < pos2.x and \
			ev.position.y > pos1.y and ev.position.y < pos2.y
			
func button_iterate(delta):
	if delta + button_index >= 0 and delta + button_index < len(button_order):
		set_button_index(button_index + delta)

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
	if button_name == "options":
		$OptionsMenu.visible = true
		$OptionsMenu.enabled = true
		enabled = false

	elif button_name == "left":
		change_level(-1)
	elif button_name == "right":
		change_level(1)
	elif button_name == "play":
		match selected_level:
			1:
				SaveSystem.change_scene("res://worlds/world1/World1.tscn", -1)
			2:
				SaveSystem.change_scene("res://worlds/world2/World2Start.tscn", -1)
			3:
				SaveSystem.change_scene("res://worlds/world3/World3.tscn", -1)
	return
		
func hover_button(button_name):
	if button_name != button_clicked:
		show_button(button_name, 2)

func show_button(button, index):
	var base = get_node(button)
	var hover = get_node(button+"_hover")
	var clicked = get_node(button+"_clicked")
	base.visible = index == 1
	hover.visible = index == 2
	clicked.visible = index == 3
	
func change_level_1():
	change_level(1 - selected_level)

func change_level(delta=0):
	PlayerStats.set_hp(2)
	print(selected_level)
	if selected_level + delta >= 1 and selected_level + delta <= level_count \
		and (selected_level + delta == 1 or SaveSystem.get_level_data(selected_level, false)[0] == "T" or delta < 1):
		levels[selected_level - 1].visible = false
		selected_level += delta
		levels[selected_level - 1].visible = true
		SaveSystem.get_level_data(selected_level)
		display_lock(SaveSystem.get_level_data(selected_level)[0] != "T")
	else:
		print(SaveSystem.get_level_data(selected_level, false))
	

func unlock_level():
	$LockIcon.play("unlock")
	level_count += 1
	
	
func _ready():
	get_node("HUD").show_only_score()
	change_level(0)
	SaveSystem.load_game()
	PlayerStats.initialize_HUD()
	yield(get_tree().create_timer(0.1), "timeout")
	enabled = true

	
func display_lock(visibility):
	$LockIcon.visible = visibility

func _on_OptionsMenu_enable_menu():
	enabled = true
