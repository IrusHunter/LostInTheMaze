class_name StartMenu
extends Control

const path: String = "res://Scenes/UserInterface/Menus/StartMenu/start_menu.tscn"

func _ready():
	$Options.hide()
	var tmp = DirAccess.make_dir_absolute("user://Data/Saves")
	if tmp == 0: 
		Global.copy_dirs("res://UserData/StartData/Data/", "user://Data/")


func _on_quit_button_pressed():
	get_tree().quit()
func _on_play_button_pressed():
	get_tree().change_scene_to_file(GameSelection.path)
func _on_options_button_pressed():
	$Options.show()
func _on_upload_button_pressed():
	Global.copy_dirs(Global.start_data_path, Global.user_path)
	print("Update complete")
