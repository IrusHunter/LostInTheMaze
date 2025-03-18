class_name GameData
## contains general information about current game

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
		if _section == 0:
			return "Origin" ## Зародження
		return ""
	set(value):
		_section = int(value)
		_data_saver.save_data()
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
