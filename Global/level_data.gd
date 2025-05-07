class_name LevelData
## general information about level

var _current_layer: int = 0 ## id (height) of current map layer
var _first_loaded: bool = true ## indicator that helps speed up level loading
var _data_saver: DataSaver

## constructor for instance
## [b]path[/b] - path without extention to the level data savefile
func _init(path: String) -> void:
	_data_saver = DataSaver.new(path, _init_dictionary)
	_init_from_dictionary()

## id (height) of current map layer
var current_layer: int:
	get:
		return _current_layer
	set(value):
		_current_layer = value
		_data_saver.save_property("current_layer", str(_current_layer))
## indicator that helps speed up level loading
var first_loaded: bool:
	get:
		return _first_loaded
	set (value): 
		if _first_loaded:
			_first_loaded = value
			_data_saver.save_property("first_loaded", str(int(_first_loaded)))

## func for data_saver
func _init_dictionary() -> Dictionary:
	var d: Dictionary = {}
	d["current_layer"] = str(_current_layer)
	d["first_loaded"] = str(int(_first_loaded))
	return d

## func for extract info from data_saver
func _init_from_dictionary():
	var d = _data_saver.get_data()
	_current_layer = int(d["current_layer"])
	_first_loaded = bool(int(d["first_loaded"]))
