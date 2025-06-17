class_name GameSelectionMenu
extends Control

## path to scene
const PATH: String = "res://Scenes/Menus/GameSelectionMenu/game_selection_menu.tscn"
@onready var _game_stories_conteiner: BoxContainer = $GameStoriesContainer

func _ready():
	var dir = DirAccess.open(Paths.SAVES_PATH)
	for d in dir.get_directories():
		GameStory.init(_game_stories_conteiner, Vector2(0,0), d)
	GameStory.init(_game_stories_conteiner, Vector2(0,0), "")

func _on_right_shift_button_pressed():
	_game_stories_conteiner.position.x -= 100
	for gs: GameStory in _game_stories_conteiner.get_children():
		gs.reset()

func _on_left_shift_button_pressed():
	_game_stories_conteiner.position.x += 100
	for gs: GameStory in _game_stories_conteiner.get_children():
		gs.reset()
