class_name Health

#region fields
var _current_health: float
var _top_health: float
var _is_death: bool = false
signal health_changed
signal top_health_changed
signal death
#endregion

func _init(health: float, death_func: Callable):
	_current_health = health
	_top_health = health
	death.connect(death_func)

#region properties
var current_health: float:
	get: 
		return _current_health
	set(value):
		if value > _top_health:
			value = _top_health
		_current_health = value
		if _current_health < 0 and not _is_death:
			_is_death = true
			death.emit()
		health_changed.emit()
var top_health: float:
	get: 
		return _top_health
	set(value):
		_top_health = value
		if _current_health > _top_health:
			current_health = _top_health
		top_health_changed.emit()
#endregion
