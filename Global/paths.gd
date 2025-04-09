class_name Paths
## generate paths to get data and manipulate with directories

const START_DATA_PATH = "res://UserData/"
const USER_PATH = "user://Data/"
const SAVES_PATH = USER_PATH + "Saves/"

## returns path to [b]level_name[/b] level data folder in [b]game_name[/b] game
static func get_level_path(game_name: String, level_name: String) -> String:
	if level_name == "":
		printerr("cannot get current_game_path: options_data doesn't contain it")
		return ""
	return "".join([get_game_path(game_name), level_name,"/"])

## returns path to [b]level_name[/b] level start data 
static func get_start_level_path(level_name: String) -> String:
	if level_name == "":
		printerr("cannot get current_game_path: options_data doesn't contain it")
		return ""
	return "".join([START_DATA_PATH, "Levels/", level_name,"/"])

## returns path to [b]game_name[/b] data folder
static func get_game_path(game_name: String) -> String:
	if game_name == "":
		printerr("game_name is empty")
	return "".join([SAVES_PATH, game_name, "/"])

## coping files from [b]from[/b] directory to [b]to[/b] directory
static func copy_dirs(from: String, to: String) -> void:
	var fromDirectory = DirAccess.open(from)
	DirAccess.make_dir_absolute(to)
	var toDirectory = DirAccess.open(to)
	for dir in fromDirectory.get_directories():
		toDirectory.make_dir(dir)
		copy_dirs(from+dir+"/", to+dir+"/")
	for file in fromDirectory.get_files():
		DirAccess.copy_absolute(from+file, to+file)

## deletes files and directories from [b]dir_path[/b] directory[br]
## doesn't delete main directory
static func delete_files(dir_path: String) -> void:
	var dir = DirAccess.open(dir_path)
	if dir == null:
		return
	for d in dir.get_directories():
		delete_files(dir_path + d + '/')
	for f in dir.get_files():
		DirAccess.remove_absolute(dir_path + f)
