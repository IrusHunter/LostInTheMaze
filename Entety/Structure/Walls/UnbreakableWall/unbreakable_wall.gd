class_name UnbreakableWall
extends StaticBody2D

#region fields
const path: String = "res://Entety/Structure/Walls/UnbreakableWall/unbreakable_wall.tscn"
var _priority: int
#endregion\

func _ready():
	_priority = NeighborsControlModule.priorities.UNBREAKABLE
static func init(parent: Node, position: Vector2, rotation: float) -> UnbreakableWall:
	var uw = preload(path).instantiate()
	parent.add_child(uw)
	uw.position = position
	uw.rotation = rotation
	return uw
static func init_from_file(parent: Node, file: String) -> UnbreakableWall:
	var uwf = FileAccess.open(file, FileAccess.READ)
	var line = uwf.get_line().split(' ', false)
	var rotation: float
	if line[2] == "1":
		rotation = 0
	else:
		rotation = PI/2
	var uw = init(
		parent, Wall.get_position(Vector2(int(line[0]), int(line[1])), bool(int(line[2]))), rotation
	) 
	return uw

#region properties
var priority: int:
	get:
		return _priority
#endregion

#region metods
#func save_to_file() -> void:
	#var swf = FileAccess.open(_save_path, FileAccess.WRITE)
	#var pos = Wall.get_tile_map_position(position)
	#var rot: int
	#if rotation > PI/2 - 0.2:
		#rot = 0
	#else:
		#rot = 1
	#swf.save(
		#str(pos.x) + " " + str(pos.y) + " " + str(rot) + " " + str(_health.top_health - _health.current_health)
	#)
	#swf.close()
#endregion

