class_name ContinueLastGameWindow
extends Control
## window that allows continue play the last game or select the new one

## path to scene
const PATH: String = "res://Scenes/UserInterface/Menus/StartMenu/ContinueLastGameWindow/continue_last_game_window.tscn"
@warning_ignore("unused_private_class_variable")
var _background_panel: BackgroundPanel 
@onready @warning_ignore("unused_private_class_variable") 
var _background_container: Control = $BackgroundContainer
@onready @warning_ignore("unused_private_class_variable") 
var _texure_rect: TextureRect = $TextureRect ## main node
@onready @warning_ignore("unused_private_class_variable") 
var _info_label: Label = $TextureRect/InfoLabel

## constructor for scene
static func init(parent: Node) -> ContinueLastGameWindow:
	var s = preload(PATH).instantiate()
	parent.add_child(s)
	s._info_label.text = s.tr("LABEL_CONTINUE_LAST_GAME").format({"game_name": Global.game_data.name})
	s._background_panel = BackgroundPanel.init(s._background_container, s._texure_rect, s._close_menu)
	return s

## on close function
func _close_menu() -> void:
	self.hide()

func _on_continue_button_pressed() -> void:
	pass # jump into the game

func _on_select_game_button_pressed() -> void:
	get_tree().change_scene_to_file(GameSelection.PATH)
