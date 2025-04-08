class_name DialogueTreeSpeechNode
extends DialogueTreeNode
## node is responsible for deliver the character words

var _words: String ## main character speech
var _next_node: String ## next noded key
var _activate_dialogue_func: Callable ## connection to the Dialogue node [br]([b]func(String) -> void[/b]

## [b]w[/b] - main character speech [br]
## [b]next[/b] - next node key [br]
## [b]activate_dialogue[/b] - connection to the Dialogue ([b]func(String) -> void[/b])
func _init(w: String, next: String, activate_dialogue: Callable) -> void:
	_words = w
	_next_node = next
	_activate_dialogue_func = activate_dialogue

func to_next_node() -> String:
	_activate_dialogue_func.call(_words)
	return _next_node
