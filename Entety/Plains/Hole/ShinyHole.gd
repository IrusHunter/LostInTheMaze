class_name ShinyHole
extends Sprite2D

const path: String = "res://Entety/Plains/Hole/ShinyHole.tscn"
var timeForFlashing = 0

func _process(delta):
	timeForFlashing += delta*2
	modulate.a = abs(sin(timeForFlashing))
