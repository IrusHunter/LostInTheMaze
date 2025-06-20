class_name Joystick 
extends Control
## Ui that give ability to change direction of something for user

const PATH: String = "res://Scenes/UserInterface/Joystick/joystick.tscn"
var _radius: float = 30 ## allowable distance for pointer
var _cursor_pos: Vector2 = Vector2(0,0) ## position of user cursor
@onready var _pointer: TextureRect = $MainFrame/Pointer ## inside dot
## Emited when joystick has new vector. Expected method signature: [br][br]
## [gdscript]func new_vector(vec: Vector2) -> void:[/gdscript]
signal new_vector

var cursor_pos: Vector2:
	get:
		return _cursor_pos
	set(value):
		_cursor_pos = value
		
		if _cursor_pos.length() < _radius:
			_pointer.position = _cursor_pos
		else:
			_pointer.position = _cursor_pos.normalized() * _radius
		
		new_vector.emit(_pointer.position.normalized())

func _on_pointer_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		var screen_scale = min(get_viewport().get_screen_transform().x.x, get_viewport().get_screen_transform().y.y)
		cursor_pos += event.screen_relative / screen_scale
	else:
		if event is InputEventScreenTouch:
			if event.pressed:
				cursor_pos = event.position - _pointer.size/2
			else:
				cursor_pos = Vector2(0,0)
