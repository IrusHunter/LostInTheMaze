class_name ExitTile
extends Area2D

#region fields
const path: String = "res://Entety/Plains/Exit/ExitToAnotherLevel/exit.tscn"
signal input(et: ExitTile)
#endregion

func _ready():
	pass # Replace with function body.
func _init():
	pass
static func init(parent: Node, input_func: Callable, _position: Vector2) -> ExitTile:
	var et = preload(path).instantiate()
	et.input.connect(input_func)
	parent.add_child(et)
	et.position = _position
	return et

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch:
		if !event.pressed:
			input.emit(self)
