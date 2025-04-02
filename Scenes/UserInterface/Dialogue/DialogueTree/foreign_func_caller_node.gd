class_name DialogueTreeForeignFuncCallerNode
extends DialogueTreeNode
## node that call foreign func for change external states

var _next_node: String ## next node key
var _func: Callable ## foreign func with parametr [br]([b]func(String) -> void[/b])
var _parametr: String ## parametr for the function

## [b]next[/b] - next node key [br]
## [b]foreign_func[/b] - foreign func with parametr [b]func(String) -> void[/b] [br]
## [b]parametr[/b] - parametr for the function [br]
func _init(next: String, foreign_func: Callable, parametr: String) -> void:
	_next_node = next
	_func = foreign_func
	_parametr = parametr

func to_next_node() -> String:
	_func.call(_parametr)
	return _next_node
