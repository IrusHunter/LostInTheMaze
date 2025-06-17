class_name FirstScene
extends Control

static var path: String = "res://Global/FirstScene/FirstScene.tscn" ## path to scene file

func _ready() -> void:	
	Global.options_gata = OptionsData.new()
	if Global.options_gata._program_version < VersionControlSystem.CURRENT_VERSION:
		_update(Global.options_gata._program_version)
	
	Global.options_gata.program_version = VersionControlSystem.CURRENT_VERSION
	Global.game_data = GameData.new(Global.options_gata.current_game_name)
	get_tree().change_scene_to_file(StartMenu.PATH)

func _on_new_update(n: String) -> void:
	if n == "end":
		return
	
	print(n)

func _update(from: int) -> void:
	var vcs: VersionControlSystem = VersionControlSystem.new()
	vcs.new_update_phase.connect(_on_new_update)
	vcs.update(from)
