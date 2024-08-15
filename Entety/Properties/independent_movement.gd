class_name IndependentMovement
extends Node

class PositionControl:
	var x: bool
	var y: bool
	
	func _init(_x: bool, _y: bool):
		x = _x
		y = _y

#region fields
var _speed: float
var _on_move: bool = false
var _destination_point: Vector2
var _stop_sign: PositionControl
var _direction: Vector2
var _body: CharacterBody2D
signal movement_stoped
#endregion

func _init(speed: float, body: CharacterBody2D):
	_speed = speed
	_body = body
	body.add_child(self)

func _process(delta):
	if _on_move:
		_body.velocity = _direction * speed * delta
		#var s = destinationPoint > position
		var s = PositionControl.new(
			_destination_point.x < _body.position.x, _destination_point.y < _body.position.y
		)
		if (_stop_sign.x == s.x) && (_stop_sign.y == s.y):
			if (_body.move_and_slide()):
				stop_move()
		else:
			stop_move()

#region properties
var speed: float:
	get:
		return _speed
var on_move: bool:
	get:
		return _on_move
#endregion

#region metods
func start_move(position: Vector2) -> void:
	_destination_point = position
	_direction = (position - _body.position).normalized()
	_body.rotation = _direction.angle()
	_stop_sign = PositionControl.new(_body.position.x > position.x, _body.position.y > position.y)
	_on_move = true
func stop_move() -> void:
	_on_move = false
	movement_stoped.emit()
#endregion
