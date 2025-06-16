class_name Health
## represents all health points of all game objects [br]
## also used to determine damage from objects [br]
## for initiation this class with other properties use reset() [br]
## see method take_damage for more information about fields and how it work

## types of hp/resistance/shield/damage
enum HP_TYPE {BIOLOGICAL, MECHANICAL, MORAL}
const COUNT_OF_HP_TYPES = 3
#region health properties
var _hp_type: HP_TYPE ## type of the Health. Important for effects
var _current_hp: float ## current health points
var _top_hp: float ## top health points
## emited when [member _current_hp] or [member _top_hp] changed. Expected method signature: [br][br]
## [gdscript]func health_changed(hp: Health) -> void:[/gdscript]
signal health_changed
## emited when object dies. Expected method signature: [br][br]
## [gdscript]func death_func() -> void:[/gdscript]
signal death 
#endregion
#region resistance, sield
## vulnerability to damage [br]
## index - type of damage [br]
## 1.0 - default value
var _vulnerability: Array[float] = []
## shield to damage [br]
## index - type of damage [br]
## 0.0 - default value 
var _shield: Array[float] = []
signal vulnerability_changed
signal shield_changed
#endregion
var _data_saver: DataSaver

#region constructor and save
## [b]path[/b] - path to save file [br]
## [b]death_func[/b] - function that will call when the object dies [br][br]
## [gdscript]func death_func() -> void:[/gdscript]
func _init(path: String, death_func: Callable) -> void:
	death.connect(death_func)
	_vulnerability.resize(COUNT_OF_HP_TYPES)
	_vulnerability.fill(1.0)
	_shield.resize(COUNT_OF_HP_TYPES)
	_shield.fill(0.0)
	
	_data_saver = DataSaver.new(path, _init_dictionary)
	_from_dictionary(_data_saver.get_data())
	_set_default_values()

## [b]c_hp[/b] - current health points [br]
## [b]t_hp[/b] - top health points [br]
## [b]hp_t[/b] - type of the Health. Important for effects [br]
## [b]vul[/b] - [br]
## [b]sh[/b] - [br]
func reset(c_hp: float, t_hp: float, hp_t: HP_TYPE, vul: Array[float], sh: Array[float]) -> void:
	_current_hp = c_hp
	_top_hp = t_hp
	_hp_type = hp_t
	
	_set_default_values()
	for i in range(COUNT_OF_HP_TYPES):
		var v = vul.get(i)
		if v == null:
			v = 1.0
		_vulnerability[i] = v
		
		var s = sh.get(i)
		if s == null:
			s = 0.0
		_shield[i] = s

## returns default values of saved property for DataSaver
func _init_dictionary() -> Dictionary[String, String]:
	var d: Dictionary[String, String] = {}
	d["current_hp"] = str(_current_hp)
	d["top_hp"] = str(_top_hp)
	d["hp_type"] = str(_hp_type)
	d["vulnerability"] = _get_str_vul()
	d["shield"] = _get_str_sh()
	return d
## initialize (resets) intance from property dictionary [br]
## USE ONLY DICTIONARY FROM [member _data_saver]
func _from_dictionary(d: Dictionary[String, String]) -> void:
	_current_hp = float(d["current_hp"])
	_top_hp = float(d["top_hp"])
	_hp_type = int(d["hp_type"])
	
	var v_str := d["vulnerability"].split("&", false)
	var s_str := d["shield"].split("&", false)
	for i in range(COUNT_OF_HP_TYPES):
		_vulnerability[i] = float(v_str[i])
		_shield[i] = float(s_str[i])

## set immunity for health to special damage type
func _set_default_values() -> void:
	if hp_type == HP_TYPE.BIOLOGICAL:
		pass
	elif hp_type == HP_TYPE.MECHANICAL:
		_vulnerability[HP_TYPE.BIOLOGICAL] = -1.0
		_vulnerability[HP_TYPE.MORAL] = -1.0
	elif hp_type == HP_TYPE.MORAL:
		_vulnerability[HP_TYPE.BIOLOGICAL] = -1.0
		_vulnerability[HP_TYPE.MECHANICAL] = -1.0

## convert [member _vulnerability] to String
func _get_str_vul() -> String:
	var v_str: Array[String] = []
	v_str.resize(COUNT_OF_HP_TYPES)
	for i in range(COUNT_OF_HP_TYPES):
		v_str[i] = str(_vulnerability[i])
	return "&".join(v_str)
## convert [member _shield] to String
func _get_str_sh() -> String:
	var s_str: Array[String] = []
	s_str.resize(COUNT_OF_HP_TYPES)
	for i in range(COUNT_OF_HP_TYPES):
		s_str[i] = str(_shield[i])
	return "&".join(s_str)
#endregion

#region properties
## getter and setter for [member _current_hp] [br]
## emit health_changed and death when necessary
var current_hp: float:
	get: 
		return _current_hp
	set(value):
		if value > _top_hp:
			value = _top_hp
		
		if value < 0 and not is_dead:
			death.emit()
		_current_hp = value
		_data_saver.save_property("current_hp", str(current_hp))
		health_changed.emit(self)

## getter and setter for [member _top_hp] [br]
## when new value <0 don't change field [member _top_hp] [br]
## clips current_health if it is more then new value
var top_hp: float:
	get: 
		return _top_hp
	set(value):
		if value < 0:
			return
		_top_hp = value
		
		if _current_hp > _top_hp:
			_current_hp = _top_hp
		health_changed.emit()
## return true when [member _current_hp] below 0
var is_dead: bool:
	get:
		return _current_hp < 0
## getter for [member _hp_type]
var hp_type: HP_TYPE:
	get:
		return _hp_type

## getter for [member _vulnerability]
var vulnerability: Array[float]:
	get:
		return _vulnerability
## getter for [member _shield]
var shield: Array[float]:
	get:
		return _shield

## multiplies the current [b]type[/b] vulnerability by [b]value[/b] [br]
## emited vulnerability_changed signal
func increase_vulnerability(type: HP_TYPE, value: float) -> void:
	_vulnerability[type] *= value
	_data_saver.save_property("vulnerability", _get_str_vul())
	vulnerability_changed.emit(type)
## divides the current [b]type[/b] vulnerability by [b]value[/b] [br]
## emited vulnerability_changed signal
func reduce_vulnerability(type: HP_TYPE, value: float) -> void:
	increase_vulnerability(type, 1/value)

## increase the current [b]type[/b] shield by [b]value[/b] [br]
## emited shield_changed signal
func increase_shield(type: HP_TYPE, value: float) -> void:
	_shield[type] += value
	_data_saver.save_property("shield", _get_str_sh())
	shield_changed.emit(type)
## reducec the current [b]type[/b] shield by [b]value[/b] [br]
## emited shield_changed signal
func reduce_shield(type: HP_TYPE, value: float) -> void:
	increase_shield(type, -value)
#endregion

## main function for getting gamage by other object
func take_damage(damager: Health) -> void:
	var t: HP_TYPE = damager.hp_type
	var vul := _vulnerability[t] * damager.vulnerability[_hp_type]
	var sh := _shield[t] - damager.shield[_hp_type]
	if sh < 0:
		sh = 0.0
	
	var damage := vul * damager.current_hp - sh
	if damage < 0:
		return
	current_hp -= damage
