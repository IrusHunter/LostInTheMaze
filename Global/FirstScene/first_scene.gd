class_name FirstScene
extends Control

static var path: String = "res://Global/FirstScene/FirstScene.tscn" ## path to scene file

func _ready() -> void:
	Global.game_data = GameData.new("test")
	#Global.game_data.section = "1"
	get_tree().change_scene_to_file(StartMenu.PATH)
