class_name Global

#region settings data
static var version: int
static var sounds_level = 0
static var music_level = 0
static var options_gata: OptionsData ## contain general information about the program
#endregion
#region paths
const start_data_path = "res://UserData/StartData/"
const user_path = "user://Data/"
const init_unit_path = "user://Data/for_init_units.txt"
const saves_path = user_path + "Saves/"
#endregion
static var game_data: GameData ## general data about current game
#region level data
const size = 32
#endregion


static var void_visibility: bool = false

static func copy_dirs(from: String, to: String) -> void:
	var fromDirectory = DirAccess.open(from)
	var toDirectory = DirAccess.open(to)
	for dir in fromDirectory.get_directories():
		toDirectory.make_dir(dir)
		copy_dirs(from+dir+"/", to+dir+"/")
	for file in fromDirectory.get_files():
		copy_files(from+file, to+file)

static func _ready():
	pass
	#var tmp = DirAccess.make_dir_absolute("user://Data/Saves")
	#if tmp == 0: 
		#copy_dirs("res://UserData/StartData/Data/", "user://Data/")


static func copy_files(fromFilePath, toFilePath) -> void:
	#var fF = FileAccess.open(fromFilePath, FileAccess.READ)
	#var tF = FileAccess.open(toFilePath, FileAccess.WRITE)
	#FileAccess.get_open_error()
	#while !(fF.eof_reached()):
		#tF.store_line(fF.get_line())
	#fF.close()
	#tF.close()
	DirAccess.copy_absolute(fromFilePath, toFilePath)

static func delete_files(dir_path: String) -> void:
	var dir = DirAccess.open(dir_path)
	for d in dir.get_directories():
		delete_files(dir_path + d + '/')
	for f in dir.get_files():
		DirAccess.remove_absolute(dir_path + f)
