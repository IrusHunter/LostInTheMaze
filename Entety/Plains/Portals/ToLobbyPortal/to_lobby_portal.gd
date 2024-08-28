class_name ToLobbyPortal
extends Area2D

#region fields
const path: String = "res://Entety/Plains/Portals/ToLobbyPortal/to_lobby_portal.tscn"
var _save_path: String = Global.init_unit_path
#endregion

static func init(parent: Node, _position: Vector2) -> ToLobbyPortal:
	var et = preload(path).instantiate()
	parent.add_child(et)
	et.position = _position
	return et
static func init_from_file(parent: Node, file: String) -> ToLobbyPortal:
	var etf = FileAccess.open(file, FileAccess.READ)
	var line = etf.get_line().split(' ', false)
	var et = init(
		parent, Vector2(int(line[0]), int(line[1])) * Global.size + Vector2(Global.size / 2, Global.size / 2)
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
			for b in get_overlapping_bodies():
				if not b.get("independent_movement") == null:
					ToLobbyTeleporter.start_teleportation()
