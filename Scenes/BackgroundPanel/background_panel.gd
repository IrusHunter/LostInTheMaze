class_name BackgroundPanel
extends Panel
## panel that hides the [member _main_node] when user tap outside of it

## path to scene
const PATH: String = "res://Scenes/BackgroundPanel/background_panel.tscn"
var _main_node: Control ## main node that needs the background
var _on_close_func: Callable ## activate on time to close. Format: [b]func() -> void[/b]

## [b]mn[/b] - main control node that needs the background
## [b]f[/b] - function that activate on time to close. Format: [b]func() -> void[/b]
static func init(parent: Node, mn: Control, f: Callable) -> BackgroundPanel:
	var s = preload(PATH).instantiate()
	parent.add_child(s)
	s._main_node = mn
	s._on_close_func = f
	return s

func _on_gui_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event is InputEventScreenTouch:
		if not event.pressed:
			var actual_position = event.position - _main_node.position
			if (actual_position.x < 0) or (actual_position.y < 0):
				_on_close_func.call()
			elif (actual_position.x > _main_node.size.x) or (actual_position.y > _main_node.size.y):
				_on_close_func.call()
