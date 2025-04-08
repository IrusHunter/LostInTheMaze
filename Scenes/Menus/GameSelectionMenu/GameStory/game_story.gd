class_name GameStory
extends Control
## several panels create, continue. Continue shows game data about concrete game

## path to scene
const PATH: String = "res://Scenes/Menus/GameSelectionMenu/GameStory/game_story.tscn"

#region info panel
@onready var _info_panel: Panel = $Info
@onready var _name_lable: Label = $Info/NameOfTheStory
@onready var _section_lable: Label = $Info/Section
@onready @warning_ignore("unused_private_class_variable") var _location_label: Label = $Info/Location 
## доробити (GameData не містить цього поля, поки що)
#endregion
#region new save panel
@onready var _new_save_panel: Panel = $NewSave
@onready var _new_save_name_source: LineEdit = $NewSave/NameEnter
@onready var _error_label: Label = $NewSave/Error
#endregion
@onready @warning_ignore("unused_private_class_variable") var _main_button: TextureButton = $MainButton
var _game_data: GameData

func _ready():
	_info_panel.hide()
	_new_save_panel.hide()

## [b]pos[/b] - start position (up-left angel) of story [br]
## [b]n[/b] - name of the game story
static func init(parent: Node, pos: Vector2, n: String) -> GameStory:
	var gs: GameStory = preload(PATH).instantiate()
	parent.add_child(gs)
	gs.position = pos
	gs._game_data = GameData.new(n)
	if n != "":
		gs._load_from_game_data()
	return gs

#region metods
## resets the class state to default
func reset():
	_info_panel.hide()
	_new_save_panel.hide()
func _load_from_game_data() -> void:
	if _game_data.name != "":
		_name_lable.text = _game_data.name
		_section_lable.text = tr("LABEL_SECTION").format({"section": _game_data.section})
#endregion

func _on_main_button_pressed():
	if _game_data.name == "":
		_new_save_panel.show()
	else:
		_info_panel.show()

func _on_create_new_save_pressed():
	var err: String = _game_data.create_new_game(_new_save_name_source.text)
	if err == "":
		Global.game_data = _game_data
		get_tree().change_scene_to_file(Level.PATH)
		return
	_error_label.text = tr(err)

func _on_panel_gui_input(event: InputEvent) -> void:
	if _info_panel.visible or _new_save_panel.visible:
		if event is InputEventScreenTouch:
			if not event.pressed:
				reset()

func _on_continue_button_pressed() -> void:
	Global.game_data = _game_data
	get_tree().change_scene_to_file(Level.PATH)
