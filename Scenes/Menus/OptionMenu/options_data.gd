class_name OptionsData
## contain general information about the program

var _current_game_name: String = "" ## name of current game
var _program_version: int = 0 ## version of the program
var _music_level: int = 50 ## loudness of music
var _sound_level: int = 50 ## loudness of sounds
var _brightness: float = 1 ## brightness of the program
var _fog_brightness: float = 0.5 ## brightness of fog
var _memory_brightness: float = 0.5 ## brightness of objects in the main character memory
var _default_camera_zoom: float = 4 ## default zoom for camera
var _data_saver: DataSaver

func _init() -> void:
	_data_saver = DataSaver.new(Paths.USER_PATH + "options", _init_dictionary)
	_init_from_dictionary()

## name of current game
var current_game_name: String:
	get:
		return _current_game_name
	set(value):
		_current_game_name = value
		_data_saver.save_property("current_game_name", _current_game_name, true)

## loudness of music
var music_level: int:
	get:
		return _music_level
	set(value):
		if value > 0 and value < 100:
			_music_level = value
		elif value < 0:
			_music_level = 0
		elif value > 100:
			_music_level = 100
		_data_saver.save_property("music_level", str(_music_level))

## loudness of sounds
var sound_level: int:
	get:
		return _sound_level
	set(value):
		if value > 0 and value < 100:
			_sound_level = value
		elif value < 0:
			_sound_level = 0
		elif value > 100:
			_sound_level = 100
		_data_saver.save_property("sound_level", str(_sound_level))

## current game localization
var language: String:
	get:
		return TranslationServer.get_locale()
	set(value):
		var supported_languages = ["en", "ua"]  
		if supported_languages.has(value):
			TranslationServer.set_locale(value)
		else:
			TranslationServer.set_locale("en")
		_data_saver.save_property("language", language)

## brightness of the program
var brightness: float:
	get: 
		return _brightness
	set(value):
		_brightness = value
		_data_saver.save_property("brightness", str(_brightness))

## brightness of fog
var fog_brightness: float:
	get: 
		return _fog_brightness
	set(value):
		_fog_brightness = value
		_data_saver.save_property("fog_brightness", str(_fog_brightness))

## brightness of objects in the main character memory
var memory_brightness: float:
	get: 
		return _memory_brightness
	set(value):
		_memory_brightness = value
		_data_saver.save_property("memory_brightness", str(_memory_brightness))

## version of the program
var program_version: int:
	get:
		return _program_version
	set(value):
		_program_version = value
		_data_saver.save_property("program_version", value, true)

## default zoom for camera
var default_camera_zoom: float:
	get: 
		return _default_camera_zoom
	set(value):
		_default_camera_zoom = value
		_data_saver.save_property("camera_zoom", str(_default_camera_zoom))

## func for data_saver
func _init_dictionary() -> Dictionary:
	var d: Dictionary = {}
	d["current_game_name"] = _current_game_name
	d["program_version"] = str(_program_version)
	d["music_level"] = str(_music_level)
	d["sound_level"] = str(_sound_level)
	d["language"] = language
	d["brightness"] = str(_brightness)
	d["fog_brightness"] = str(_fog_brightness)
	d["default_camera_zoom"] = str(_default_camera_zoom)
	return d

## func for extract info from data_saver
func _init_from_dictionary():
	var d = _data_saver.get_data()
	_current_game_name = d["current_game_name"]
	_program_version = int(d["program_version"])
	_music_level = int(d["music_level"])
	_sound_level = int(d["sound_level"])
	language = d["language"] 
	_brightness = float(d["brightness"])
	_fog_brightness = float(d["fog_brightness"])
	_default_camera_zoom = float(d["default_camera_zoom"])
