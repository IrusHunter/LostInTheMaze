class_name BodiesMover

#region fields
var _speed_multiplier: float
#endregion

func _init(speed_multiplier: float):
	_speed_multiplier = speed_multiplier
static func init(speed_multiplier: float = 1) -> BodiesMover:
	return BodiesMover.new(speed_multiplier)

#region metods
func move_body_to(body, position: Vector2) -> void:
	if body.has_meta("independent_movement"):
		if body.independent_movement.on_move:
			await body.independent_movement.movement_stoped
		body.independent_movement.start_move(position)
	else:
		print("Body, that BodiesMover can`t move")
		breakpoint
#endregion
