class_name GameStory
extends Control

#region fields
const path: String = "res://Scenes/UserInterface/Menus/SelectionGameStory/GameStory/game_story.tscn"
var _save_path: String = ""
@onready var _info_panel: Panel = $Info
@onready var _main_button: TextureButton = $TextureButton
@onready var _name_lable: Label = $Info/NameOfTheStory
@onready var _stage_lable: Label = $Info/Stage
@onready var _part_lable: Label = $Info/Part
@onready var _location_label: Label = $Info/Location
@onready var _new_save_panel: Panel = $NewSave
@onready var _new_save_name_source: TextEdit = $NewSave/TextEdit
#endregion

func _ready():
	_info_panel.hide()
	_new_save_panel.hide()
	if _save_path == "":
		pass
	else:
		var gsf = FileAccess.open(_save_path + "main.txt", FileAccess.READ)
		_name_lable.text = _save_path.get_slice('/', _save_path.get_slice_count('/') - 2)
		_stage_lable.text = tr("labelGameStoryStage") + ": \"" + tr(gsf.get_line()) + "\""
		_part_lable.text = tr("labelGameStoryPart") + ": \"" + tr(gsf.get_line()) + "\""
		_location_label.text = tr("labelGameStoryLocation") + ": \"" + tr(gsf.get_line()) + "\""
		gsf.close()
static func init(parent: Node, position: Vector2, dir: String) -> GameStory:
	var gs: GameStory = preload(path).instantiate()
	gs._save_path = dir
	parent.add_child(gs)
	gs.position = position
	return gs

#region metods
func reset():
	_on_button_2_pressed()
#endregion

func _on_texture_button_pressed():
	if _save_path == "":
		_new_save_panel.show()
	else:
		_info_panel.show()

func _on_button_pressed():
	Global.current_level = _name_lable.text
	get_tree().change_scene_to_file(Level.path)

func _on_button_2_pressed():
	_info_panel.hide()
	_new_save_panel.hide()

func _on_create_new_save_pressed():
	DirAccess.make_dir_absolute(Global.saves_path)
	DirAccess.make_dir_absolute(Global.saves_path + _new_save_name_source.text)
	Global.copy_dirs(Global.start_data_path + "Save", Global.saves_path + _new_save_name_source.text)
	Global.current_level = "1_FirstLevel"
	get_tree().change_scene_to_file(Level.path)
