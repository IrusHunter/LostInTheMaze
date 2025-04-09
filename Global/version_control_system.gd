class_name VersionControlSystem
## responsible for update user data from any version to current

const CURRENT_VERSION: int = 1
signal new_update_phase ## pass one String parametr - key of the update

## update game from any version to current
func update(from: int) -> void:
	if from <= 0:
		_from_0_to_1()
	new_update_phase.emit("end")

func _from_0_to_1():
	new_update_phase.emit("something")
	DirAccess.make_dir_recursive_absolute(Paths.SAVES_PATH)
	var sf = FileAccess.open(Paths.USER_PATH + "Options.txt", FileAccess.WRITE)
	sf.store_line("program_version=1")
