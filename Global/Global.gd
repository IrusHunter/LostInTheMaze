extends Node

#region settings data
var sounds_level = 0
var music_level = 0
#endregion
#region path
var current_level = "1_FirstLevel"
var start_data_path = "res://UserData/StartData/"
var user_path = "user://Data/"
var init_unit_path = "user://Data/for_init_units.txt"
var game_story = "Test1"
var saves_path = user_path + "Saves/"
var tmp_level_path = user_path + "CurrentLevel/"
#endregion

var size = 32
var game_name: String = ""

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

func at_the_start_of_game(from: String, to: String):
	var fromDirectory = DirAccess.open(from)
	var toDirectory = DirAccess.open(to)
	for dir in fromDirectory.get_directories():
		toDirectory.make_dir(dir)
		at_the_start_of_game(from+"/"+dir, to+"/"+dir)
	for file in fromDirectory.get_files():
		copy_files(from+"/"+file, to+"/"+file)
func copy_dirs(from: String, to: String):
	at_the_start_of_game(from, to)

func _ready():
	var tmp = DirAccess.make_dir_absolute("user://Data/Saves")
	if tmp == 0: 
		at_the_start_of_game("res://UserData/StartData/Data", "user://Data")
	
	#var fSett = FileAccess.open(user_path+"Settings.txt", FileAccess.READ)
	#music_level = float(fSett.get_line())
	#sounds_level = float(fSett.get_line())
	#fSett.close()

func copy_files(fromFilePath, toFilePath):
	var fF = FileAccess.open(fromFilePath, FileAccess.READ)
	var tF = FileAccess.open(toFilePath, FileAccess.WRITE)
	FileAccess.get_open_error()
	while !(fF.eof_reached()):
		tF.store_line(fF.get_line())
	fF.close()
	tF.close()





