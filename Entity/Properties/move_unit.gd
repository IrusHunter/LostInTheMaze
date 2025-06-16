class_name MoveUnit
extends Node

#region fields
var _max_speed: float
var _speed: float
#var _external_direction: Vector2
var _direction: Vector2
var _body: CharacterBody2D
signal movement_stoped
#endregion

func _init(speed: float, max_speed: float, body: CharacterBody2D):
	_speed = speed
	_max_speed = max_speed
	_body = body
	body.add_child(self)

func _process(delta):
	_body.velocity = _direction * _speed * delta
	_body.move_and_slide()

#region metods
func change_direction(new_v: Vector2) -> void:
	_body.rotation = new_v.angle()
	_speed = _max_speed * new_v.length()
	_direction = new_v.normalized()
	if new_v.length() < 0.001:
		movement_stoped.emit()
#func start_move(position: Vector2) -> void:
	#_destination_point = position
	#_direction = (position - _body.position).normalized()
	#_body.rotation = _direction.angle()
	#_stop_sign = PositionControl.new(_body.position.x > position.x, _body.position.y > position.y)
	#_on_move = true
#endregion
