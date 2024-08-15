class_name Wall

static func get_position(tile_map_pos: Vector2i, is_vertical: bool) -> Vector2:
	var tmp_result = Vector2(tile_map_pos * Global.size)
	if is_vertical:
		return tmp_result + Vector2(0, Global.size / 2)
	else:
		return tmp_result + Vector2(Global.size / 2, 0)
static func get_tile_map_position(pos: Vector2) -> Vector2i:
	var tmp_result = (pos + Vector2(1,1) * Global.size/4) / Global.size
	tmp_result.x = int(tmp_result.x)
	tmp_result.y = int(tmp_result.y)
	return tmp_result

static func init_walls(parent: Node, dir: String) -> void:
	var d = DirAccess.open(dir)
	var walls: Array = []
	for f in d.get_files():
		var type = f.split('_')
		match type[0]:
			"StoneWall":
				walls.append(StoneWall.init_from_file(parent, dir + f))
			"StealWall":
				walls.append(StealWall.init_from_file(parent, dir + f))
			"UnbreakableWall":
				walls.append(UnbreakableWall.init_from_file(parent, dir + f))
	for w in walls:
		if w.has_meta("neighbors_control_module"):
			w._anim.code = w.neighbors_control_module.get_neighbor_walls()
	for w in walls:
		if w.has_meta("neighbors_control_module"):
			w.neighbors_control_module.remove()
