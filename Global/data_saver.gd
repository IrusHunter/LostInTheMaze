class_name DataSaver
## Saves data to file in concrete format

var _dict_func: Callable ## function, that returns [b]{String:String}[/b]
var _path: String ## path to file

## [b]path[/b] - path to file [br]
## [b]f[/b] - function, that returns [b]{String:String}[/b]
func _init(p: String, f: Callable) -> void:
	_dict_func = f
	_path = p + ".txt"

## Saves data to [member path] in format [b]"key&&value"[/b]
func save_data() -> void:
	var pF = FileAccess.open(_path, FileAccess.WRITE)
	var d: Dictionary = _dict_func.call()
	for key in d.keys():
		pF.store_line(key + "=" + d[key])

## Read data from path file. [br]
## Return a [b]{String:String}[/b]
func get_data() -> Dictionary:
	var pF = FileAccess.open(_path, FileAccess.READ)
	var lines = pF.get_as_text().split('/n')
	var d = _dict_func.call()
	for l in lines:
		l = l.split("=")
		d[l[0]] = l[1]
	return d

## save only 1 property
func save_property(_key: String, _value: String) -> void:
	save_data()
