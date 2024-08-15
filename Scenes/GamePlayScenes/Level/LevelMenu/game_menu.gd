extends Control
##DON'T CHANGE ANYTHING HERE, LOOR AT LEVEL SCRIPT
func _ready():
	hide()
	$Options.hide()

func _on_continiune_button_pressed():
	hide()
func _on_options_button_pressed():
	$Options.show()
func _on_return_to_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/UserInterface/Menus/MainMenu.gd")
func _on_return_to_lobby_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/UserInterface/Lobby/Lobby.gd")
