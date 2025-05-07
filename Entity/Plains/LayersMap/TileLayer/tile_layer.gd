class_name TileLayer
extends TileMapLayer
## one tile layer for game

const PATH: String = "res://Entity/Plains/LayersMap/TileLayer/tile_layer.tscn"
const PIXELS_PER_METER = 8
var _horizontal_walls: Dictionary = {}
var _vertical_walls: Dictionary = {}

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
			var tile_pos = Vector2i(i, colum) + start_position
			var tile_id = int(lines[i])
			if Global.level_data.first_loaded and tile_id >= 0:
				tl._tile_added_at(tile_pos)
			tl.set_cell(tile_pos, tile_id, Vector2i(0,0))
		colum += 1
		lines = tmf.get_line().split(' ', false)
	tmf.close()
	
	return tl
func _ready() -> void:
	var scale_delta: float = float(Level.PIXELS_PER_METER) / float(PIXELS_PER_METER)
	scale = Vector2(scale_delta, scale_delta)

## dictionary [b]{Vector2i: flag}[/b] [br]
## [b]Vector2i[/b] - tile position of horizontal wall
## [b]flag[/b] - if only 1 tile connected to this wall
var horizontal_walls: Dictionary:
	get:
		return _horizontal_walls
## dictionary [b]{Vector2i: flag}[/b] [br]
## [b]Vector2i[/b] - tile position of vertical wall
## [b]flag[/b] - if only 1 tile connected to this wall
var vertical_walls:Dictionary:
	get:
		return _vertical_walls

## calculated walls tile position after input tile position
func _tile_added_at(pos: Vector2i) -> void:
	var h_poses := [pos, pos + Vector2i(0,1)]
	for p in h_poses:
		if _horizontal_walls.get(p) == null:
			_horizontal_walls[p] = true
		elif _horizontal_walls[p]:
			_horizontal_walls[p] =false
	
	var v_poses := [pos, pos + Vector2i(1,0)]
	for p in v_poses:
		if _vertical_walls.get(p) == null:
			_vertical_walls[p] = true
		elif _vertical_walls[p]:
			_vertical_walls[p] =false
	
