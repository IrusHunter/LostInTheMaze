class_name DialogueTreeConditionNode
extends DialogueTreeNode
## node that choose the next node by [member _condition_func] result

var _next_nodes: Array ## string array with dialogue tree node keys
var _condition_func: Callable ## main qualifier [br][b]func() -> int[/b]

## [b]next_nodes[/b] - string array with dialogue tree node keys [br]
## [b]condition[/b] - main qualifier ([b]func() -> int[/b])
func _init(next_nodes: Array, condition: Callable) -> void:
	_next_nodes = next_nodes
	_condition_func = condition

func to_next_node() -> String:
	var i: int = _condition_func.call()
	if i < 0:
		i = 0
	elif i >= len(_next_nodes):
		i = len(_next_nodes) - 1
	return _next_nodes[i]
