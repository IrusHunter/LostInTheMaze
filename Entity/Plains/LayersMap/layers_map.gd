class_name LayersMap
## container for tile layers

var _layers: Dictionary ## dictionary with all layers with heights {int: TileLayer}
var _current_layer: int = 0 ## height of current layer

##[b]dir_path[/b] - path to directory with all layers files[br]
##[b]parent[/b] - for layers[br]
##[b]current_layer[/b] - height of current layer[br]
func _init(dir_path: String, parent: Node, current_layer: int) -> void:
	var dir = DirAccess.open(dir_path)
	for file in dir.get_files():
		_layers[int(file.get_file().get_basename())] = TileLayer.init(parent, dir_path + file)
	
	_current_layer = current_layer
	for a in _layers.keys():
		if current_layer == a:
			_layers[a].show()
		else:
			_layers[a].hide()

## current visible layer
var current_layer: TileLayer:
	get:
		return _layers[_current_layer]
