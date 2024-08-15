@tool
extends EditorScript

func _run() -> void:
	for i in range(100):
		var line = ""
		for j in range(100):
			line += "0 "
		print(line)
