class_name GameData
## contains general information about current game

const SECTIONS: PackedStringArray = ["SECTION_ORIGINS", "SECTION_INTO_DARKNESS"] ## contains section names
var _name: StringName = "" ## game name
var _section: int = 0 ## code of game paragraph
var _current_level_name: StringName = "LEVEL_FIRST" ## name of the current level 
var _data_saver: DataSaver

## [b]n[/b] - game name [br]
## if you need default value, pass [b]""[/b] to [b]n[/b]
func _init(n: String):
	if n == "":
		return
	_name = n
	_data_saver = DataSaver.new(Paths.get_game_path(n) + "main_data", _init_dictionary)
	_init_from_dictionary()

#region fields
## returns in-game name of section [br]
## to set use int value in string brackets ([b]"1"[/b])
var section: String: 
	get:
		if _section >= 0:
			return SECTIONS[_section]
		return ""
var name: String:
	get:
		return _name
var current_level_name: StringName:
	get:
		return _current_level_name
	set(value):
		_current_level_name = value
		_data_saver.save_property("current_level", _current_level_name)
#endregion

## func for data_saver
func _init_dictionary() -> Dictionary:
	var d: Dictionary = {}
	d["section_id"] = str(_section)
	d["current_level"] = _current_level_name
	return d

## func for extract info from data_saver
func _init_from_dictionary():
	var d = _data_saver.get_data()
	_section = int(d["section_id"])
	_current_level_name = d["current_level"]

## passing to the next section of game
func go_to_the_next_section() -> void:
	_section += 1
	if _section > len(SECTIONS):
		_section -= 1
		return
	_data_saver.save_property("section_id", str(_section))

## takes new name for the story and return error in String format ("" if all good)
func create_new_game(new_name: String) -> String:
	var dir = DirAccess.open(Paths.SAVES_PATH)
	
	if _name != "":
		return "ERROR_DATA_ALREADY_EXISTS"
	
	if new_name in dir.get_directories():
		return "ERROR_GAME_ALREADY_EXISTS"
	
	var err = dir.make_dir(new_name)
	if err != OK:
		return "ERROR_MAKING_DIR_FAILED"
	
	_name = new_name
	_data_saver = DataSaver.new(Paths.get_game_path(_name) + "main_data", _init_dictionary)
	_data_saver.save_data()
	DirAccess.make_dir_absolute(Paths.get_game_path(_name) + "CurrentLevel")
	return ""
