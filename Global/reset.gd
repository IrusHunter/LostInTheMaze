@tool
extends EditorScript

func at_the_start_of_game(from: String, to: String):
	var fromDirectory = DirAccess.open(from)
	var toDirectory = DirAccess.open(to)
	for dir in fromDirectory.get_directories():
		toDirectory.make_dir(dir)
		at_the_start_of_game(from+"/"+dir, to+"/"+dir)
	for file in fromDirectory.get_files():
		copy_files(from+"/"+file, to+"/"+file)
func copy_files(fromFilePath, toFilePath):
	var fF = FileAccess.open(fromFilePath, FileAccess.READ)
	var tF = FileAccess.open(toFilePath, FileAccess.WRITE)
	FileAccess.get_open_error()
	while !(fF.eof_reached()):
		tF.store_line(fF.get_line())
	fF.close()
	tF.close()
func _run():
	at_the_start_of_game("res://UserData/StartData", "user://Data")
	print("save updated")
