class_name Chest

static func init_chests(parent: Node, dir: String) -> void:
	var d = DirAccess.open(dir)
	#var chests: Array = []
	for f in d.get_files():
		var type = f.split('_')
		match type[0]:
			"Arsenal":
				#chests.append(Arsenal.init_from_file(parent, dir + f))
				Arsenal.init_from_file(parent, dir + f)
			"CommonChest":
				#chests.append(CommonChest.init_from_file(parent, dir + f))
				CommonChest.init_from_file(parent, dir + f)
	Level.current_num_of_ls += 1
