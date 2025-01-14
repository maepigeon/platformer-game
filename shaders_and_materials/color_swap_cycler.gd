#API:
#set-colors (array of colors) sets the color palette for the sprite
#cycle_palette(cycle_time_amt,  palette, smoothing_time, number_of_cycles)
#cycle_palettes(cycle_time_amt, palettes_arr, smoothing_time, number_of_cycles)
#stop_loop - abruptly ends the cycling, leaving you at the current color

extends Node2D

export(NodePath) var sprite_path
export(int) var number_of_colors = 11
export(float) var dynamicSpeed = 0 #set to 0.1 for 10fps

onready var palettes = $palettes.get_children()
onready var tweenNode = $Tween
onready var cycle_palettes_arr = [palettes[0], palettes[1]]

#represents the colorset in memory that is being tweened
var current_color_palette = grayColors 
var end_palette	#the palettes that we are transitioning between

var dynamicOn : bool = true
var dynamicColors = [Color(0.95, 0.78, 0.36),\
					Color(0.98, 0.64, 0.40),\
					Color(0.97, 0.43, 0.32),\
					Color(0.93, 0.24, 0.22),\
					Color(0.82, 0.10, 0.24)]
					
var dyna2		 = [Color(0.55, 0.78, 0.36),\
					Color(0.48, 0.64, 0.40),\
					Color(0.57, 0.43, 0.32),\
					Color(0.73, 0.24, 0.22),\
					Color(0.62, 0.10, 0.24)]
var grayColors = 	[Color(0.00, 0.00, 0.00),\
					Color(0.1, 0.1, 0.1),\
					Color(0.2, 0.2, 0.2),\
					Color(0.3, 0.3, 0.3),\
					Color(0.4, 0.4, 0.4),\
					Color(0.5, 0.5, 0.5),\
					Color(0.60, 0.60, 0.60),\
					Color(0.7, 0.7, 0.7),\
					Color(0.8, 0.8, 0.8),\
					Color(.9, .9, .9),\
					Color(1, 1, 1)]
		
#values that can be temporarily modified for the tweening
#sorta hacky but I have no idea how to set the value that is being
#changed to an array index. NOT TO BE SET MANUALLY
var c1 = Color(0, 0, 0)
var c2 = Color(0, 0, 0)
var c3 = Color(0, 0, 0)
var c4 = Color(0, 0, 0)
var c5 = Color(0, 0, 0)
var c6 = Color(0, 0, 0)
var c7 = Color(0, 0, 0)
var c8 = Color(0, 0, 0)
var c9 = Color(0, 0, 0)
var c10 = Color(0, 0, 0)
var c11 = Color(0, 0, 0)

#when the tween is completed
func _on_Tween_tween_completed(_object, _key):
	tweenNode.stop_all()
	_change_dynamic_speed(1)

#do this when interpolating between values
func _on_Tween_tween_step(_object, _key, _elapsed, value):
	var colors = [
		c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11
	]
	colors.resize(current_color_palette.size())
	set_colors(colors)
	
#starts smoothly transitioning the position of the parent
func start_tweening_position(tweenTime, deltaPos : Vector2):
	dynamicOn = true
	var parent = get_node("../")
	tweenNode.interpolate_property(parent, "position", parent.position, \
		parent.position + deltaPos, tweenTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) 
	tweenNode.start()
	
#smoothly changes the color palette of the sprite from startPalette to endPalette 
#over tweenTime
func tween_between_color_palettes(startPalette, endPalette):
	tweenNode.stop_all()
	end_palette = endPalette
	if startPalette.size() != endPalette.size():
		print("Color palettes must be the same size to tween")
	else:
		current_color_palette = startPalette
		dynamicOn = true
		for colorIndex in range(startPalette.size()): 
			tweenNode.interpolate_property(self, "c%s" % (colorIndex + 1), startPalette[colorIndex], \
				end_palette[colorIndex], dynamicSpeed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) 
			tweenNode.start()
	
#changes the default time to transition between colors
func _change_dynamic_speed(value):
	dynamicSpeed = value
	dynamicOn = value > 0
	if dynamicOn:
		tweenNode.start()
	else:
		tweenNode.stop_all()

		
var cycle_time_current = 0
var cycle_time = 0 			#the how much time it has been cycling
							#(shouold be less than the cycle time)
var cycle_type = 0 			#0: is not set to cycle
							#1: is set to cycle through multiple palettes based
							#2:	is set to cycle through the colors in one palette, skipping null colors
							#3: indefinitely loop through multiple palettes until told to stop
							#4: indefinitely loop through multiple palettes until tolt to stop
var cycle_index 			#if the cycle is set to loop, this is the current Iterations.
							#should be zero when not cycling
var cycle_loop_limit : int 	#if the cycle is set to loop, this is the amount of iterations
							#that will happen before being reset and stopped
						
#start cycling through the values of the specified color palette
#if the number of cycles is 0, loop indefinitely until something calls stop_loop()
func cycle_palettes(cycle_time_amt, palettes_arr, smoothing_time, number_of_cycles):
	cycle_time = cycle_time_amt
	cycle_time_current = 0
	cycle_loop_limit = number_of_cycles
	_change_dynamic_speed(smoothing_time)
	end_palette = palettes_arr[1]
	if number_of_cycles == 0:
		cycle_type = 4
	else:
		cycle_type = 2
#start cycling through the values of the specified color palette
#if the number of cycles is zero, loop indefinitely until something calls stop_loop()
func cycle_palette(cycle_time_amt,  palette, smoothing_time, number_of_cycles):
	cycle_time = cycle_time_amt
	cycle_time_current = 0
	cycle_index = 0
	cycle_loop_limit = number_of_cycles
	_change_dynamic_speed(smoothing_time)
	end_palette = rotate_arr(current_color_palette)
	tween_between_color_palettes(current_color_palette, end_palette)
	if number_of_cycles == 0:
		cycle_type = 3
	else:
		cycle_type = 1

#ends the looping of the color swap
func stop_loop():
	cycle_time_current = 0
	cycle_index = 0
	cycle_loop_limit = 0
	cycle_time = 0
	cycle_type = 0
	tweenNode.stop_all()
	
var rotated_palettes_temp #holds the rotated array of palettes or colors

		
#simply returns an array that has been right-rotated by one
func rotate_arr(array):
	var size = array.size()
	if size < 2:
		return array
	var rotated_arr = array.duplicate(true)
	var last_index = rotated_arr[0]
	for i in range(size - 1):
		rotated_arr[i] = rotated_arr[i + 1]
	rotated_arr[size - 1] = last_index 
	#print(rotated_arr)
	return rotated_arr

#runs every frame
func _process(delta):
	var time_up = false
	match cycle_type:
		1, 2, 3, 4:
			cycle_time_current += delta
			time_up =cycle_time_current >= cycle_time
			if time_up:
				cycle_time_current = 0
				cycle_index += 1
				if cycle_type == 1 or cycle_type == 3: #1 palette (iterate colors)
					current_color_palette = end_palette
					end_palette = rotate_arr(current_color_palette)
					tween_between_color_palettes(current_color_palette, end_palette)
				if cycle_type == 2 or cycle_type == 4:  #palettes (iterate colors)
					end_palette = rotate_arr(cycle_palettes_arr)
					#else:
					#	stop_loop()
		_:
			pass
			
func _ready():
	_change_dynamic_speed(0) #don't cycle
	set_to_default()
	set_colors(palettes[0].get_colors())
	#set_colors(dynamicColors)
	_change_dynamic_speed(1) #now cycle
	#dyna2 = rotate_arr(rotate_arr(dynamicColors))
	#tween_between_color_palettes(dynamicColors, dyna2)
	#start_tweening_position(3, Vector2(-40, 0))
	#tween_between_color_palettes(palettes[0].get_colors(), palettes[1].get_colors())
	#tween_between_color_palettes(palettes[0].get_colors(), rotate_arr(rotate_arr(rotate_arr(rotate_arr(rotate_arr(palettes[0].get_colors()))))))
	#cycle_palette(.1, dynamicColors, .1, 0)

#sets the colors to the default colors
func set_to_default():
	set_colors(grayColors)
	

#sets the colors to the specified ones
func set_colors(color_set):
	var shaderMat = get_node(sprite_path).get_material()
	current_color_palette = color_set
	
	shaderMat.set_shader_param("numberOfColors", color_set.size())
	for color in range(color_set.size()):
		shaderMat.set_shader_param("C%s" % (color + 1), color_set[color])
