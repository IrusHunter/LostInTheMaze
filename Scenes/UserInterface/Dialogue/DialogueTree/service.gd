class_name DialogueService
extends Node
## controls loading and saving of DialogueTreeNode [br]
## use it in game objects, that participate in any dialogues

var _nodes: Array[String] ## all keys of nodes from directory
var _node_directory: String ## path to directory with node save path

## [b]d_path[/b] - path to the directory of the nodes [br]
static func init(parent: Node, d_path: String) -> DialogueService:
	var ds = DialogueService.new()
	parent.add_child(ds)
	
	ds._node_directory = d_path
	ds._load_nodes()
	DialogueTree.add_service(ds)
	
	return ds

## returns all possible nodes after [b]node[/b] [br]
## if there is no possible nodes, returns empty array
func try_get_possible_nodes(nodes: Array[String]) -> Array[DialogueTreeNode]:
	var result: Array[DialogueTreeNode] = []
	for n in nodes:
		var node := _get_node(n)
		if node == null:
			continue
		result.append(node)
	
	return result

## starts the new dialogue from [b]start_node[/b] [br]
## [b]start_node[/b] - key of the node
func start_dialogue(start_node: String) -> void:
	DialogueTree.start_dialogue(_get_node(start_node))

## fabric for nodes
func _get_node(key: String) -> DialogueTreeNode:
	if _nodes.find(key) == -1:
		return null
	return DialogueTreeNode.new(Paths.get_dialogue_node_path(_node_directory, key), key)

## loading all node keys from [member _node_directory]
func _load_nodes() -> void:
	var dir := DirAccess.open(_node_directory)
	for file in dir.get_files():
		_nodes.append(file.get_basename())

func _exit_tree() -> void:
	DialogueTree.remove_service(self)
