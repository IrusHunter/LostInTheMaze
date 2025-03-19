class_name StartMenu
extends Control

const FOLDER_PATH: String = "res://Scenes/UserInterface/Menus/StartMenu/"
const PATH: String = FOLDER_PATH + "start_menu.tscn"
@onready var backfround: TextureRect = $Background
@onready var play_button: TextureButton = $PlayButton
@onready var options_button: TextureButton =  $OptionsButton
@onready var quit_button: TextureButton = $QuitButton
@onready var options: Control = $Options

func _ready():
	options.hide()
	var assets: String = FOLDER_PATH + "Assets/" + Global.game_data.section + "/"
	var buttons = [play_button, options_button, quit_button]
	var names = ["PlayButton", "OptionsButton", "QuitButton"]
	for i in range(len(buttons)):
		buttons[i].texture_normal = load(assets + names[i] + "Normal.png")
		buttons[i].texture_pressed = load(assets + names[i] + "Normal.png")
		buttons[i].texture_hover = load(assets + names[i] + "Normal.png")
	backfround.texture = load(assets + "Background.png")
	#var tmp = DirAccess.make_dir_absolute("user://Data/Saves")
	#if tmp == 0: 
		#Global.copy_dirs("res://UserData/StartData/Data/", "user://Data/")


func _on_quit_button_pressed():
	get_tree().quit()
func _on_play_button_pressed():
	get_tree().change_scene_to_file(GameSelection.path)
func _on_options_button_pressed():
	$Options.show()
func _on_upload_button_pressed():
	Global.copy_dirs(Global.start_data_path, Global.user_path)
	print("Update complete")
