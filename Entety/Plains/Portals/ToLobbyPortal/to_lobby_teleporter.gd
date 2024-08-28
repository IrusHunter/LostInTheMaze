class_name ToLobbyTeleporter

#region fields
static var functions: Array[Callable]
#endregion

#region metods
static func add_teleport_func(call: Callable) -> void:
	functions.append(call)
static func start_teleportation():
	for c: Callable in functions:
		c.call(Global.saves_path + Global.game_name + "/Lobby/")
#endregion
