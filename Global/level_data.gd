class_name LevelData
## contains general information about level

var _current_layer: int = 0 ## id (height) of current map layer
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

## func for data_saver
func _init_dictionary() -> Dictionary:
	var d: Dictionary = {}
	d["current_layer"] = str(_current_layer)
	return d

## func for extract info from data_saver
func _init_from_dictionary():
	var d = _data_saver.get_data()
	_current_layer = int(d["current_layer"])
