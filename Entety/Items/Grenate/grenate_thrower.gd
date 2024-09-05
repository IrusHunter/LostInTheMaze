class_name GrenateThrower

#region fields
var _power: float
#endregion

func _init(power: float):
	_power = power
static func init(power: float) -> GrenateThrower:
	return new(power)

#region metods
func throw_grenate(g: Grenate, vec: Vector2) -> void:
	g.apply_impulse(vec * _power)
#endregion
