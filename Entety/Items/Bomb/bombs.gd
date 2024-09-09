class_name Bombs

#region fields
static var parent_node: Node
static var save_dir: String
#endregion

static func init_bombs(parent: Node, dir: String) -> void:
	parent_node = parent
	save_dir = dir
	var d = DirAccess.open(dir)
	for f in d.get_files():
		var type = f.split('_')
		match type[0]:
			"Bomb":
				Bomb.init_from_file(parent, dir + f)
	Level.current_num_of_ls += 1

