class_name ExitTile
extends Area2D

#region fields
const path: String = "res://Entety/Plains/Exit/ExitToAnotherLevel/exit.tscn"
var _save_path: String = Global.init_unit_path
signal input(et: ExitTile)
#endregion

func _ready():
	pass # Replace with function body.
func _init():
	pass
static func init(parent: Node, input_func: Callable, _position: Vector2) -> ExitTile:
	var et = preload(path).instantiate()
	et.input.connect(input_func)
	parent.add_child(et)
	et.position = _position
	return et
static func init_from_file(parent: Node, input_func: Callable, file: String) -> ExitTile:
	var etf = FileAccess.open(file, FileAccess.READ)
	var line = etf.get_line().split(' ', false)
	var et = init(
		parent, input_func, 
		Vector2(int(line[0]), int(line[1])) * Global.size + Vector2(Global.size / 2, Global.size / 2)
	)
	et._save_path = file
	etf.close()
	return et

#region metods
func save_to_file() -> void:
	var etf = FileAccess.open(_save_path, FileAccess.READ)
	var pos = Level.to_tilemap_coords(position)
	etf.store_line(str(pos.x) + " " + str(pos.y))
	etf.close()
#endregion

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch:
		if !event.pressed:
			input.emit(self)
