class_name GameSelection
extends Control

#region properties
const path: String = "res://Scenes/UserInterface/Menus/SelectionGameStory/game_selection.tscn"
@onready var _game_stories_conteiner: BoxContainer = $GameStoriesContainer
#endregion

func _ready():
	var dir = DirAccess.open(Global.saves_path)
	for d in dir.get_directories():
		GameStory.init(_game_stories_conteiner, Vector2(0,0), Global.saves_path + d + "/")
	GameStory.init(_game_stories_conteiner, Vector2(0,0), "")



func _on_right_shift_button_pressed():
	_game_stories_conteiner.position.x -= 100
	for gs: GameStory in _game_stories_conteiner.get_children():
		gs.reset()

func _on_left_shift_button_pressed():
	_game_stories_conteiner.position.x += 100
	for gs: GameStory in _game_stories_conteiner.get_children():
		gs.reset()
