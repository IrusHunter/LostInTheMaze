class_name DataSaver
## Saves data to file in concrete format [br]
## Use ConfigFile as basic [br]

const EXTENSION: String = ".cfg" ## extension for files
enum SECTION {DEFAULT, GAME_OBJECT} ## type of parent object for group saving
## Array with arrays with DataSavers. Type:
## [codeblock]
## Array[Array[DataSaver]]
## _sections[SECTION] = Array[DataSaver]
## [/codeblock]
static var _sections: Array = []
var _dict_func: Callable ## function, that returns [b]{String:String}[/b]
var _path: String ## path to file
var _config_file: ConfigFile = ConfigFile.new()

static func _static_init() -> void:
	_sections.append([])
	_sections.append([])

## [b]path[/b] - path to file without extension [br]
## [b]f[/b] - function, that returns Dictionary with properties to save: [br][br]
## [gdscript]func f() -> Dictionary[String, Variant][/gdscript]
## [b]section[/b] - type of parent object
func _init(p: String, f: Callable, section: SECTION = SECTION.DEFAULT) -> void:
	_dict_func = f
	_path = p + EXTENSION
	#_config_file.load(_path)
	_sections[section].append(self)
	#import_data()

## Saves data to [b]p[/b] file with class ConfigFile [br]
## [b]p[/b] - path to file without extension ([member _path] for default) [br]
## [b]rewrite_path[/b] - if true rewrite [member _path] to p value
func save_data(p: String = _path, rewrite_path: bool = false) -> void:
	if p != _path:
		p += EXTENSION
	var err := _config_file.save(p)
	if err != OK:
		printerr("Config file ", _path, " can't be saved: ", err)
	if rewrite_path:
		_path = p

func import_data() -> void:
	var d = _dict_func.call()
	for key in d:
		_config_file.set_value("Main", key, d[key])

## Read data from [member _path] file. [br]
## Returns the Dictionary with keys from [member _dict_func] Dctionary: [br][br]
## [gdscript]Dictionary[String, Variant][/gdscript]
## If file hasn't key, sets key for default from [member _dict_func] Dctionary
func get_data() -> Dictionary:
	_config_file.load(_path)
	var def_dict = _dict_func.call()
	for key in def_dict:
		def_dict[key] = _config_file.get_value("Main", key, def_dict[key])
	return def_dict

## Saves (rewrite) only 1 property
## [b]key[/b] - key of property [br]
## [b]value[/b] - new value of property [br]
## [b]save_to_file[/b] - rewrite save file if true (false for default)
func save_property(key: String, value: Variant, save_to_file: bool = false) -> void:
	_config_file.set_value("Main", key, value)
	if save_to_file:
		save_data()

## Saves data to files for all DataSavers in section [b]s[/b]
static func save_section(s: SECTION) -> void:
	for ds: DataSaver in _sections[s]:
		ds.save_data()
