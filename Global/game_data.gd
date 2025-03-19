class_name GameData
## contains general information about current game

const SECTIONS: PackedStringArray = ["Origins", "Into darkness"] ## contains section names
var _name: String ## game name
var _section: int ## code of game paragraph
var _data_saver: DataSaver

## [b]n[/b] - game name
func _init(n: String):
	_name = n
	_data_saver = DataSaver.new(Global.saves_path + _name + "/main_data.txt", _init_dictionary)
	_init_from_dictionary()

## returns in-game name of section [br]
## to set use int value in string brackets ([b]"1"[/b])
var section: String: 
	get:
		if _section > 0:
			return SECTIONS[_section]
		return ""
var name: String:
	get:
		return _name

## func for data_saver
func _init_dictionary() -> Dictionary:
	var d: Dictionary = {}
	d["section_id"] = str(_section)
	return d

## func for extract info from data_saver
func _init_from_dictionary():
	var d = _data_saver.get_data()
	_section = int(d["section_id"])

## passing to the next section of game
func go_to_the_next_section() -> void:
	_section += 1
	if _section > len(SECTIONS):
		_section -= 1
		return
	_data_saver.save_data()
