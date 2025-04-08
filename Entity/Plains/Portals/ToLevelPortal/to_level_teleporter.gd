class_name ToLevelTeleporter

#region fields
var _level_path: String
static var functions: Array[Callable]
#endregion

func _init(level_path: String):
	_level_path = level_path
static func init(level_path: String) -> ToLevelTeleporter:
	return ToLevelTeleporter.new(level_path)

#region metods
static func add_teleport_func(call: Callable) -> void:
	functions.append(call)
func start_teleportation() -> void:
	for c: Callable in functions:
		c.call(_level_path)
#endregion
