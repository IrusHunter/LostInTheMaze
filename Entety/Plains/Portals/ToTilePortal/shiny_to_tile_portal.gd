class_name ShinyToTilePortal
extends Sprite2D

const path: String = "res://Entety/Plains/Portals/ToTilePortal/shiny_to_tile_portal.tscn"
var _time_for_flashing: float = 0

func _process(delta):
	_time_for_flashing += delta*2
	modulate.a = abs(sin(_time_for_flashing))
