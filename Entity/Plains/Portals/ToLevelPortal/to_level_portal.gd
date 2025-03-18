class_name ToLevelPortal
extends Area2D

class LevelData:
	var area: int
	var total_moves: int
	var count_of_death: int
	var count_of_teleport: int # on level
	var path_to_im: String
	var to_level_teleporter: ToLevelTeleporter
	func _init(
		_area: int, _total_moves: int, _count_of_death: int, _count_of_teleport: int, _path_to_im: String,
		_to_level_path: String
	):
		area = _area
		total_moves = _total_moves
		count_of_death = _count_of_death
		count_of_teleport = _count_of_teleport
		path_to_im = _path_to_im
		to_level_teleporter = ToLevelTeleporter.init(_to_level_path)

#region fields
const path := "res://Entity/Plains/Portals/ToLevelPortal/to_level_portal.tscn"
var _in_node_panel: InNodePanel
@onready var _level_selection_panel: Panel = $LevelSelection
@onready var _levels_buttons: PopupMenu = $LevelSelection/MenuBar/Levels
var _levels: Array[LevelData] = []
@onready var _area_label: Label = $LevelSelection/Area
@onready var _total_moves_label: Label = $LevelSelection/TotalMoves
@onready var _count_of_death_label: Label = $LevelSelection/CountofDeath
@onready var _count_of_teleport_label: Label = $LevelSelection/CountofTeleport
@onready var _image: TextureRect = $LevelSelection/TextureRect
var _current_level_data: LevelData
var _save_path: String = Global.init_unit_path
#endregion

func _ready():
	_in_node_panel = InNodePanel.init(self, _level_selection_panel)
	
	_levels_buttons.clear()
	var dir := DirAccess.open(Global.saves_path + Global.game_data.name + "/Levels/")
	var counter: int = 0
	for d in dir.get_directories():
		var f := FileAccess.open(Global.saves_path + Global.game_data.name + "/Levels/" + d + "/main.txt", FileAccess.READ)
		_levels_buttons.add_item(tr(d), counter)
		counter += 1
		var line = f.get_line().split(' ', false)
		_levels.append(LevelData.new(
			int(line[0]), int(line[1]), int(line[2]), int(line[3]), 
			Global.saves_path + Global.game_data.name + "/Levels/" + d + "/texture.png",
			Global.saves_path + Global.game_data.name + "/Levels/" + d + "/"
		))
		f.close()
	reset(_levels[0])
	_in_node_panel.hide()
static func init(parent: Node, position: Vector2) -> ToLevelPortal:
	var tlt: ToLevelPortal = preload(path).instantiate()
	parent.add_child(tlt)
	tlt.position = position
	return tlt
static func init_from_file(parent: Node, file: String) -> ToLevelPortal:
	var etf = FileAccess.open(file, FileAccess.READ)
	var line = etf.get_line().split(' ', false)
	var et = init(
		parent, Vector2(int(line[0]), int(line[1])) * Global.size + Vector2(Global.size / 2, Global.size / 2)
	)
	et._save_path = file
	etf.close()
	return et


#region metods
func reset(level_data: LevelData) -> void:
	_current_level_data = level_data
	_area_label.text = tr("labelToLevelTeleportArea") + ": " + str(level_data.area)
	_total_moves_label.text = tr("labelToLevelTeleportTotalMoves") + ": " + str(level_data.total_moves)
	_count_of_death_label.text = tr("labelToLevelTeleportCountOfDeath") + ": " + str(level_data.count_of_death)
	_count_of_teleport_label.text = tr("labelToLevelTeleportCountOfTeleport") + ": " + str(level_data.count_of_teleport)
	_image.texture = ImageTexture.create_from_image(Image.load_from_file(level_data.path_to_im))
func save_to_file() -> void:
	var etf = FileAccess.open(_save_path, FileAccess.READ)
	var pos = Level.to_tilemap_coords(position)
	etf.store_line(str(pos.x) + " " + str(pos.y))
	etf.close()
#endregion

func _on_levels_id_pressed(id):
	reset(_levels[id])

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if not event.pressed:
			for body in get_overlapping_bodies():
				if not body.get("independent_movement") == null:
					_in_node_panel.show()

func _on_play_pressed():
	_current_level_data.to_level_teleporter.start_teleportation()
