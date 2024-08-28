@tool
extends EditorScript

func create_matrix() -> void:
	for i in range(100):
		var line = ""
		for j in range(100):
			line += "0 "
		print(line)

func get_dirs() -> void:
	var d = DirAccess.open("res://UserData/StartData/Save/Levels/")
	for dir in d.get_directories():
		print(dir)

func _run() -> void:
	get_dirs()
	print('-'.unicode_at(0))
