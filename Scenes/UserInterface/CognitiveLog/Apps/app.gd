class_name CognitiveLogApp
extends Control
## app at cognitive log

const PATH = "res://Scenes/UserInterface/CognitiveLog/Apps/app.tscn"
## denote position of all avaliable apps (expect BLOCKED app)
enum AvaliableApps {DIALOGUE, CHARACTER, ITEM, INTUITION, BLOCKED} 

var _current_app: AvaliableApps = AvaliableApps.BLOCKED ## point out what kind of app is loaded
@onready var _anim: AnimatedSprite2D = $Anim ## main animation node
@onready var _app_name_label: Label = $Label ## shows name of the app

static func init(parent: Node, app: AvaliableApps = AvaliableApps.BLOCKED) -> CognitiveLogApp:
	var cla: CognitiveLogApp = preload(PATH).instantiate()
	parent.add_child(cla)
	
	cla._load_app(app)
	
	return cla

## use to reset app instance
func _load_app(new_app: AvaliableApps) -> void:
	# dictionary that contains string name for apps
	var name_list: Dictionary[AvaliableApps, String] = {
		AvaliableApps.DIALOGUE: "dialogue",
		AvaliableApps.CHARACTER: "character",
		AvaliableApps.ITEM: "item",
		AvaliableApps.INTUITION: "intuition",
		AvaliableApps.BLOCKED: "blocked",
	}
	
	_current_app = new_app
	_anim.play(name_list[new_app] + "_calm")
	_app_name_label.text = name_list[new_app].to_upper() + "_CALM"
