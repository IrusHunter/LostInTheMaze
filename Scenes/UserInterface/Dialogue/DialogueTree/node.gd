class_name DialogueTreeNode
## node for DialogueTree [br]
## contains words of character

## main character speech [br]
## key - localization, value - speech
var _words: Dictionary[String, String]
var _key: String = "" ## identifier of the node
## next node for default identifier [br]
## empty if node is the last one
var _default_next: String = ""
var _data_saver: DataSaver

## [b]path[/b] - path to node [br]
## [b]node_key[/b] - identifier of the node [br]
func _init(path: String, node_key: String) -> void:
	_data_saver = DataSaver.new(path, _init_dictionary)
	_from_dictionary(_data_saver.get_data())
	_key = node_key

## returns character speech for current localization
var words: String:
	get:
		return _words[TranslationServer.get_locale()]
## return identifier of the node
var key: String:
	get:
		return _key

## returns default values of saved property for DataSaver
func _init_dictionary() -> Dictionary[String, String]:
	var d: Dictionary[String, String] = {}
	for loc in _words:
		d[loc] = _words[loc]
	d["default_next"] = _default_next
	return d
## initialize (resets) intance from property dictionary [br]
## USE ONLY DICTIONARY FROM [member _data_saver]
func _from_dictionary(d: Dictionary[String, String]) -> void:
	#_words["en"] = d["en"]
	for l in TranslationServer.get_loaded_locales():
		_words[l] = d.get(l, d["en"])
	_default_next = d["default_next"]

## return next node identifier [br]
## empty if node is the last one
func get_next_node_key() -> String:
	return _default_next

## returns keys of all possible next nodes
func get_next_possible_nodes_keys() -> Array[String]:
	return [_default_next]
