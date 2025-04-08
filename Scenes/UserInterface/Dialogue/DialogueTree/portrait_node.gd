class_name DialogueTreePortraitNode
extends DialogueTreeNode
## node is responsible for deliver the character portrait

var _next_node: String ## next noded key
var _change_portrait_func: Callable ## connection to the Dialogue node [br]([b]func(String) -> void[/b]
var _portrain_path: String ## path to portrait picture

## [b]next[/b] - next node key [br]
## [b]change_portrait[/b] - connection to the Dialogue ([b]func(String) -> void[/b]) [br]
## [b]portrait[/b] - path to portrait picture
func _init(next: String, change_portrait: Callable, portrait: String):
	_next_node = next
	_change_portrait_func = change_portrait
	_portrain_path = portrait

func to_next_node() -> String:
	_change_portrait_func.call(_portrain_path)
	return _next_node
