class_name ShinyToTilePortal
extends Sprite2D

const path: String = "res://Entety/Plains/Portals/ToTilePortal/shiny_to_tile_portal.tscn"
var _time_for_flashing: float = 0

static func init(position: Vector2) -> ShinyToTilePortal:
	var sttp: ShinyToTilePortal = preload(path).instantiate()
	EntityMessageParent.add_child(sttp)
	sttp.position = position
	sttp.hide()
	return sttp


func _process(delta):
	_time_for_flashing += delta*2
	modulate.a = abs(sin(_time_for_flashing))



