class_name FirstScene
extends Control

static var path: String = "res://Global/FirstScene/FirstScene.tscn" ## path to scene file

func _ready() -> void:
	var dir = DirAccess.open(Global.saves_path)
	if dir == null:
		return
	Global.options_gata = OptionsData.new()
	Global.game_data = GameData.new(Global.options_gata.current_game_name, Global.options_gata.current_game_name == "")
	#Global.game_data.section = "1"
	get_tree().change_scene_to_file(StartMenu.PATH)
