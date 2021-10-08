extends Node2D

export (Array, Color, RGB) var colors = \
					[Color(0.00, 0.00, 0.00),\
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

func get_colors():
	return colors
