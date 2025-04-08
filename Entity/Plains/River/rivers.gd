class_name Rivers

#region fields
static var rivers: Array[River]
#endregion

static func init_rivers(parent: Node, dir: String) -> void:
	rivers.clear()
	var d = DirAccess.open(dir)
	for f in d.get_files():
		rivers.append(River.init_from_file(parent, dir + f))
	Level.current_num_of_ls += 1
