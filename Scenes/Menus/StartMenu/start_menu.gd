class_name StartMenu
extends Control

const FOLDER_PATH: String = "res://Scenes/Menus/StartMenu/"
const PATH: String = FOLDER_PATH + "start_menu.tscn"
var continue_game_menu: ContinueLastGameWindow
@onready var backfround: TextureRect = $Background
@onready var play_button: TextureButton = $PlayButton
@onready var options_button: TextureButton =  $OptionsButton
@onready var quit_button: TextureButton = $QuitButton
@onready var popup_container: Node = $PopupContainer

func _ready():
	var assets: String = FOLDER_PATH + "Assets/" + Global.game_data.section + "/"
	var buttons = [play_button, options_button, quit_button]
	var names = ["PlayButton", "OptionsButton", "QuitButton"]
	for i in range(len(buttons)):
		buttons[i].texture_normal = load(assets + names[i] + "Normal.png")
		buttons[i].texture_pressed = load(assets + names[i] + "Normal.png")
		buttons[i].texture_hover = load(assets + names[i] + "Normal.png")
	backfround.texture = load(assets + "Background.png")
	
	continue_game_menu = ContinueLastGameWindow.init(popup_container)
	continue_game_menu.hide()


func _on_quit_button_pressed():
	get_tree().quit()
func _on_play_button_pressed():
	if Global.options_gata.current_game_name == "":
		get_tree().change_scene_to_file(GameSelectionMenu.PATH)
	else:
		continue_game_menu.show()
func _on_options_button_pressed():
	return
func _on_upload_button_pressed():
	Paths.delete_files(Paths.USER_PATH)
	Paths.copy_dirs("user://Data2/", Paths.USER_PATH)
	print("Update complete")
