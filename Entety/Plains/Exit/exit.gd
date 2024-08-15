class_name Exit

static func init_exits(parent: Node, dir_path: String, input_func: Callable) -> void:
	var dir = DirAccess.open(dir_path)
	for f in dir.get_files():
		ExitTile.init_from_file(parent, input_func, dir_path + f)

