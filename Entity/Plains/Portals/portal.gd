class_name Portal

static func init_portals(parent: Node, dir: String) -> void:
	var d = DirAccess.open(dir)
	for f in d.get_files():
		var type = f.get_slice('_', 0)
		match type:
			"ToLobbyPortal":
				ToLobbyPortal.init_from_file(parent, dir + f)
			"ToLevelPortal":
				ToLevelPortal.init_from_file(parent, dir + f)
			"ToTilePortal":
				ToTilePortal.init_from_file(parent, dir + f)
	Level.current_num_of_ls += 1
