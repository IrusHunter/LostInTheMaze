class_name CognitiveLog
extends Control
## Manual (tablet) of the game  [br]
## Complements dynamically during the game [br]
## One for game story

const PATH = "res://Scenes/UserInterface/CognitiveLog/cognitive_log.tscn"

var _background_panel: BackgroundPanel
@onready var _main_content: Control = $MainContent ## clips the tablet screnn (content)
@warning_ignore("unused_private_class_variable") 
@onready var _apps_container: GridContainer = $MainContent/AppsPanel/AppsContainer ## container for apps
 
##
static func init(parent: Node) -> CognitiveLog:
	var cl: CognitiveLog = preload(PATH).instantiate()
	parent.add_child(cl)
	
	cl._background_panel = BackgroundPanel.init(cl._main_content, cl, cl._close)
	
	return cl

func _close() -> void:
	self.hide()
	
