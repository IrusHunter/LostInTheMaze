class_name Damager

#region fields
var _damage: float
#endregion

func _init(damage: float):
	_damage = damage

#region properties
var damage: float:
	get:
		return _damage
#endregion

#region metods
func do_damage(health: Health):
	health.current_health -= damage
#endregion

