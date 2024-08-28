extends Node

#region settings data
var sounds_level = 0
var music_level = 0
#endregion
#region path
const start_data_path = "res://UserData/StartData/"
const user_path = "user://Data/"
const init_unit_path = "user://Data/for_init_units.txt"
const saves_path = user_path + "Saves/"
const size = 32
#endregion

var game_name: String
var void_visibility: bool = false

var p = 0
func slovo(st):
	var s = ""
	while (p<st.length() && st[p]==' '): 
		p += 1
	while p<st.length() && (st[p]!=' '):
		s=s+st[p]
		p += 1
	return s

func copy_dirs(from: String, to: String) -> void:
	var fromDirectory = DirAccess.open(from)
	var toDirectory = DirAccess.open(to)
	for dir in fromDirectory.get_directories():
		toDirectory.make_dir(dir)
		copy_dirs(from+dir+"/", to+dir+"/")
	for file in fromDirectory.get_files():
		copy_files(from+file, to+file)

func _ready():
	var tmp = DirAccess.make_dir_absolute("user://Data/Saves")
	if tmp == 0: 
		copy_dirs("res://UserData/StartData/Data/", "user://Data/")
	
	#var fSett = FileAccess.open(user_path+"Settings.txt", FileAccess.READ)
	#music_level = float(fSett.get_line())
	#sounds_level = float(fSett.get_line())
	#fSett.close()

func copy_files(fromFilePath, toFilePath) -> void:
	#var fF = FileAccess.open(fromFilePath, FileAccess.READ)
	#var tF = FileAccess.open(toFilePath, FileAccess.WRITE)
	#FileAccess.get_open_error()
	#while !(fF.eof_reached()):
		#tF.store_line(fF.get_line())
	#fF.close()
	#tF.close()
	DirAccess.copy_absolute(fromFilePath, toFilePath)

func delete_files(dir_path: String) -> void:
	var dir = DirAccess.open(dir_path)
	for d in dir.get_directories():
		delete_files(dir_path + d + '/')
	for f in dir.get_files():
		DirAccess.remove_absolute(dir_path + f)




