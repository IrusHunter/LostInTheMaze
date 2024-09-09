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
	if not body.get("independent_movement") == null:
		if body.independent_movement.on_move:
			await body.independent_movement.movement_stoped
		body.independent_movement.start_move(position)
	elif body is RigidBody2D:
		var imp: Vector2 = position - body.position
		if abs(imp.x) > abs(imp.y):
			imp.y = 0
		else:
			imp.x = 0
		body.apply_central_impulse(imp * body.mass * Global.size / 32)
		await body.get_tree().create_timer(0.8).timeout
		if not body == null:
			body.apply_central_impulse(-imp * body.mass * Global.size / 35)
	else:
		print("Body, that BodiesMover can`t move")
		breakpoint
#endregion
