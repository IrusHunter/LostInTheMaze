class_name ToLevelTeleporter
extends Area2D

class LevelData:
	var area: int
	var total_moves: int
	var count_of_death: int
	var count_of_teleport: int # on level
	var path_to_im: String
	func _init(_area: int, _total_moves: int, _count_of_death: int, _count_of_teleport: int, _path_to_im: String):
		area = _area
		total_moves = _total_moves
		count_of_death = _count_of_death
		count_of_teleport = _count_of_teleport
		path_to_im = _path_to_im

#region fields
const path := "res://Entety/Plains/Teleport/ToLevelTeleporter/to_level_teleporter.tscn"
var _in_node_panel: InNodePanel
@onready var _level_selection_panel: Panel = $LevelSelection
@onready var _levels_buttons: PopupMenu = $LevelSelection/MenuBar/Levels
var _levels: Array[LevelData] = []
@onready var _area_label: Label = $LevelSelection/Area
@onready var _total_moves_label: Label = $LevelSelection/TotalMoves
@onready var _count_of_death_label: Label = $LevelSelection/CountofDeath
@onready var _count_of_teleport_label: Label = $LevelSelection/CountofTeleport
@onready var _image: TextureRect = $LevelSelection/TextureRect
#endregion

func _ready():
	_in_node_panel = InNodePanel.init(self, _level_selection_panel)
	
	_levels_buttons.clear()
	var dir := DirAccess.open(Global.saves_path + Global.game_name + "/Levels/")
	var counter: int = 0
	for d in dir.get_directories():
		var f := FileAccess.open(Global.saves_path + Global.game_name + "/Levels/" + d + "/main.txt", FileAccess.READ)
		_levels_buttons.add_item(tr(d), counter)
		counter += 1
		var line = f.get_line().split(' ', false)
		_levels.append(LevelData.new(
			int(line[0]), int(line[1]), int(line[2]), int(line[3]), 
			Global.saves_path + Global.game_name + "/Levels/" + d + "/texture.png"
		))
		f.close()
	reset(_levels[0])
static func init(parent: Node, position: Vector2) -> ToLevelTeleporter:
	var tlt: ToLevelTeleporter
	parent.add_child(tlt)
	tlt.position = position
	return tlt

#region metods
func reset(level_data: LevelData) -> void:
	_area_label.text = tr("labelToLevelTeleportArea") + ": " + str(level_data.area)
	_total_moves_label.text = tr("labelToLevelTeleportTotalMoves") + ": " + str(level_data.total_moves)
	_count_of_death_label.text = tr("labelToLevelTeleportCountOfDeath") + ": " + str(level_data.count_of_death)
	_count_of_teleport_label.text = tr("labelToLevelTeleportCountOfTeleport") + ": " + str(level_data.count_of_teleport)
	_image.texture = ImageTexture.create_from_image(Image.load_from_file(level_data.path_to_im))
#endregion

func _on_levels_id_pressed(id):
	reset(_levels[id])
