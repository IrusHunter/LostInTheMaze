class_name TileLayer
extends TileMapLayer
## one tile layer for game

const PATH: String = "res://Entity/Plains/LayersMap/TileLayer/tile_layer.tscn"

##[b]parent[/b] - parent for this Node [br]
##[b]path_to_file[/b] - file with tile board [br]
##[b]start_position[/b] - start indexes for tiles [b](default: Vector2i(0,0))[/b] [br]
static func init(parent: Node, path_to_file: String, start_position: Vector2i = Vector2i(0,0)) -> TileLayer:
	var tl: TileLayer = preload(PATH).instantiate()
	parent.add_child(tl)
	tl.clear()
	
	var tmf = FileAccess.open(path_to_file, FileAccess.READ)
	var lines: PackedStringArray = tmf.get_line().split(' ', false)
	var colum = 0
	while len(lines) > 0 :
		for i in range(len(lines)):
			tl.set_cell(Vector2i(i, colum) + start_position, int(lines[i]), Vector2i(0,0))
		colum += 1
		lines = tmf.get_line().split(' ', false)
	tmf.close()
	
	return tl
