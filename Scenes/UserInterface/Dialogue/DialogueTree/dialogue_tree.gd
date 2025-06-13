class_name DialogueTree
## static servise for the Dialogue [br]
## container for all DialogueServices and connect them together

## DialogueServices from all game objects
static var _services: Array[DialogueService] = []
static var _possible_next_nodes: Array[DialogueTreeNode] = []

static func add_service(ds: DialogueService) -> void:
	_services.append(ds)
static func remove_service(ds: DialogueService) -> void:
	_services.remove_at(_services.find(ds))

## returns next node and loading possible next nodes for that
static func to_next_node(next: String) -> void:
	var next_node: DialogueTreeNode = null
	for nn in _possible_next_nodes:
		if nn.key == next:
			next_node = nn
			break
	
	if next_node != null:
		_load_possible_next_nodes(next_node)
	Dialogue._single._activate(next_node)

## updated [member _possible_next_nodes] as for node
static func _load_possible_next_nodes(node: DialogueTreeNode) -> void:
	_possible_next_nodes.clear()
	for s in _services:
		var nodes_keys := node.get_next_possible_nodes_keys()
		_possible_next_nodes.append_array(s.try_get_possible_nodes(nodes_keys))

## begining new dialogue from [b]start_node[/b] node [br]
## [b]start_node[/b] - first node of the dialogue
static func start_dialogue(start_node: DialogueTreeNode) -> void:
	_load_possible_next_nodes(start_node)
	Dialogue._single._activate(start_node)
