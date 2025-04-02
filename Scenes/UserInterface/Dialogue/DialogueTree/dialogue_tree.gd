class_name DialogueTree

var _data_saver: DataSaver
var _nodes: Dictionary ## contains all nodes [br][b]{String: DialodueTreeNode}[/b]
var _current_node: DialogueTreeNode ## current node, next to execute
var _handle_funcs: Dictionary ## contains all foreign funcs [br][b]{String: Callable}[/b]
signal _activate_dialogue ## connecting signal

var _pause: bool = false ## pause after speech node

## [b]key_name[/b] - name of the dialogue tree folder [br]
## [b]handle_funcs[/b] - contains all foreign funcs [br][b]{String: Callable}[/b] [br]
## [b]dialogue_parent[/b] - parent for the Dialogue [br]
func _init(key_name: String, handle_funcs: Dictionary, dialogue_parent: Control) -> void:
	_data_saver = DataSaver.new(
		"".join([Global.dialogue_path, Global.options_gata.language, "/", key_name]), _generate_dict
	)
	_handle_funcs = handle_funcs
	Dialogue.init(dialogue_parent, _activate_dialogue, update)
	_init_from_dict()

func _init_from_dict() -> void:
	var d = _data_saver.get_data()
	for key: String in d.keys():
		if  key[0] != '!':
			break
		key = key.replace("!","")
		var type: String = d[key]
		if type == "speech":
			_nodes[key] = DialogueTreeSpeechNode.new(
				d[key+"speech"],
				d[key+"next"],
				_emit_activation
			)
		elif type == "portrait":
			_nodes[key] = DialogueTreePortraitNode.new(
				d[key+"next"],
				_emit_activation,
				d[key+"path"]
			)
		elif type == "condition":
			_nodes[key] = DialogueTreeConditionNode.new(
				d[key+"list"].split("&"),
				_handle_funcs[d[key+"func"]]
			)
		elif type == "foreign_func":
			_nodes[key] = DialogueTreeForeignFuncCallerNode.new(
				d[key+"next"],
				_handle_funcs[d[key+"func"]],
				d[key+"parametr"]
			)
		if _current_node != null:
			_current_node = _nodes[key]

func _generate_dict() -> Dictionary:
	return Dictionary()

func _emit_activation(s: String) -> void:
	_pause = true
	_activate_dialogue.emit(s)

## call when you need to start the dialogue
func update() -> void:
	if _pause:
		_pause = false 
		return
	var n = _current_node.to_next_node()
	if n == "":
		_handle_funcs["end"].call()
		_emit_activation("")
	_current_node = _nodes[n]
