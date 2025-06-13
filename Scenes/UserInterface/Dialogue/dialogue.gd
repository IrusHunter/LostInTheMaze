class_name Dialogue
extends Control
## show dialogue to user [br]
## only one instance could be exist

const PATH: String = "res://Scenes/UserInterface/Dialogue/dialogue.tscn"
static var _single: Dialogue = null ## the single instance
var _current_node: DialogueTreeNode
var _for_back_panel_node: Control = self
var _background_panel: BackgroundPanel


static func init(parent: Node) -> Dialogue:
	var d: Dialogue = preload(PATH).instantiate()
	parent.add_child(d)
	d._background_panel = BackgroundPanel.init(d._for_back_panel_node,Control.new(), d._next_frase)
	
	if _single != null:
		_single.get_parent().remove_child(_single)
		_single.queue_free()
	_single = d
	
	return d
static func get_single() -> Dialogue:
	return _single

func _activate(node: DialogueTreeNode) -> void:
	_current_node = node
	
	if node == null:
		_end_dialogue()
		return
	if !visible:
		show()
	
		# відображення слів
	print(_current_node.words)
	_to_next_node()

func _change_portrain(s: String) -> void:
	pass

func _next_frase() -> void:
	pass

func _to_next_node() -> void:
	DialogueTree.to_next_node(_current_node.get_next_node_key())

func _end_dialogue() -> void:
	hide()
	#get_parent().remove_child(self)
	#queue_free()
