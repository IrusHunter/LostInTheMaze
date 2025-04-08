class_name Dialogue
extends Control

const PATH: String = "res://Scenes/UserInterface/Dialogue/dialogue.tscn"
var _for_back_panel_node: Control
var _background_panel: BackgroundPanel
var _next_node_func: Callable


static func init(parent: Control, update: Signal, next_node: Callable) -> Dialogue:
	var d: Dialogue = preload(PATH).instantiate()
	parent.add_child(d)
	update.connect(d._activate)
	d._next_node_func = next_node
	d._background_panel = BackgroundPanel.init(d._for_back_panel_node,Control.new(), d._next_frase)
	return d

func _activate(s: String) -> void:
	if s.is_absolute_path():
		_change_portrain(s)
	show()
	_next_node_func.call()
	if s == "":
		_end_dialogue()

func _change_portrain(s: String) -> void:
	pass

func _next_frase() -> void:
	pass

func _end_dialogue() -> void:
	get_parent().remove_child(self)
	queue_free()
