class_name Portal

static func init_portals(parent: Node, dir: String) -> void:
	var d = DirAccess.open(dir)
	#var chests: Array = []
	for f in d.get_files():
		var type = f.get_slice('_', 0)
		match type:
			"ToLobbyPortal":
				#chests.append(Arsenal.init_from_file(parent, dir + f))
				ToLobbyPortal.init_from_file(parent, dir + f)
			"ToLevelPortal":
				#chests.append(CommonChest.init_from_file(parent, dir + f))
				ToLevelPortal.init_from_file(parent, dir + f)
	Level.current_num_of_ls += 1
