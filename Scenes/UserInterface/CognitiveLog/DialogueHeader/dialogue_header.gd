class_name CognitiveLogDialogueHeader
extends Control
## Button-title for easy navigation between dialogs in the [b]CognitiveLog[/b]

const PATH = "res://Scenes/UserInterface/CognitiveLog/DialogueHeader/dialogue_header.tscn"
@warning_ignore("unused_private_class_variable") 
@onready var _importance_mark: TextureRect = $Background/ImportanceMark ## texture for mark
@warning_ignore("unused_private_class_variable") 
@onready var _star_mark: TextureRect = $Background/StartMark ## texture for star
@warning_ignore("unused_private_class_variable") 
@onready var _title_label = $Background/Title ## label for dialogue title

##[b]path[/b] - path to save file [br]
##[b]on_activate[/b] - will call when player wants to see full dialogue
static func init(parent: Node, _path: String, _on_activate: Callable) -> CognitiveLogDialogueHeader:
	var dh: CognitiveLogDialogueHeader = preload(PATH).instantiate()
	parent.add_child(dh)
	
	# to do
	
	return dh
