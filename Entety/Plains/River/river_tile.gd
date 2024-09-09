class_name RiverTile
extends Area2D

#region fields
const path: String = "res://Entety/Plains/River/river_tile.tscn"
var _next: RiverTile
var _previous: RiverTile
signal new_body(river_tile: RiverTile, body)
#endregion

func _ready():
	pass
func _init():
	pass
static func init(parent: Node, position: Vector2, previous: RiverTile) -> RiverTile:
	var r = preload(path).instantiate()
	r.previous_river_tile = previous
	parent.call_deferred("add_child", r)
	r.position = position
	return r



#region properties
var first_river_tile: RiverTile:
	get:
		var current = self
		while current.get_previous() != null: 
			current = current.get_previous()
		return current
var previous_river_tile: RiverTile:
	get:
		return _previous
	set(value):
		_previous = value
		if value != null: 
			value._next = self
var next_river_tile: RiverTile:
	get:
		return _next
	set(value):
		_next = value
		if value != null: 
			value._previous = self
var next_position: Vector2:
	get:
		if _next == null: 
			return Vector2(-1, -1)
		else: 
			return _next.position
#endregion

#region metods
#endregion

func _on_body_entered(body):
	new_body.emit(self, body)
