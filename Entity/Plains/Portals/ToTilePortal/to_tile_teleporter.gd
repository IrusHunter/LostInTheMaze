class_name ToTileTeleporter

#region fields
#endregion

func _init():
	pass
static func init() -> ToTileTeleporter:
	return new()

#region metods
func teleport_unit(body: Node2D, pos: Vector2) -> void:
	body.position = pos
#endregion
