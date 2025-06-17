class_name VersionControlSystem
## responsible for update user data from any version to current

const CURRENT_VERSION: int = 1
signal new_update_phase ## pass one String parametr - key of the update

## update game from any version to current
func update(from: int) -> void:
	if from <= 0:
		_from_0_to_1()
	#Global.options_gata._program_version = CURRENT_VERSION
	new_update_phase.emit("end")

func _from_0_to_1():
	new_update_phase.emit("something")
	DirAccess.make_dir_recursive_absolute(Paths.SAVES_PATH)
	
