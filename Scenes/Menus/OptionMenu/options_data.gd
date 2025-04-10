class_name OptionsData
## contain general information about the program

var _current_game_name: String ## name of current game
var _program_version: int ## version of the program
var _data_saver: DataSaver

func _init() -> void:
	_data_saver = DataSaver.new(Paths.USER_PATH + "Options", _init_dictionary)
	_init_from_dictionary()

## name of current game
var current_game_name: String:
	get:
		return _current_game_name
	set(value):
		_current_game_name = value
		_data_saver.save_property("current_game_name", _current_game_name)

## func for data_saver
func _init_dictionary() -> Dictionary:
	var d: Dictionary = {}
	d["current_game_name"] = _current_game_name
	d["program_version"] = str(_program_version)
	return d

## func for extract info from data_saver
func _init_from_dictionary():
	var d = _data_saver.get_data()
	_current_game_name = d["current_game_name"]
	_program_version = int(d["program_version"])
