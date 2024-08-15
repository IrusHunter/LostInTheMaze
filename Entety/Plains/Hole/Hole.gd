class_name Hole
extends Area2D

#region fields
const path: String = "res://Entety/Plains/Hole/Hole.tscn"
var next: Hole
var previous: Hole
var is_active = false
@onready var shine: ShinyHole
signal input (hole: Hole)
#endregion

func _ready():
	shine = preload(ShinyHole.path).instantiate()
	add_child(shine)
	shine.hide()
func _init():
	pass
static func init(parent: Node, input_func: Callable, _position: Vector2, _previous: Hole = null) -> Hole:
	var h = preload(path).instantiate()
	h.set_previous(_previous)
	h.input.connect(input_func)
	parent.call_deferred("add_child", h)
	h.position = _position
	return h



#region properties
func get_first_node() -> Hole:
	var current = self
	while current.get_previous() != null: 
		current = current.get_previous()
	return current

func get_previous() -> Hole:
	return previous
func set_previous(value: Hole):
	previous = value
	if value != null: value.next = self

func get_next() -> Hole:
	return next
func set_next(value: Hole):
	next = value
	if value != null: value.previous = self

func get_is_active() -> bool:
	return is_active
func set_is_active(value: bool):
	is_active = value
	shine.visible = value

func get_tag() -> String:
	return "Hole"
#endregion

#region metods
func activate_neighbors():
	if next != null: next.set_is_active(true)
	if previous != null: previous.set_is_active(true)
func disactivate_neighbors():
	if next != null: next.set_is_active(false)
	if previous != null: previous.set_is_active(false)
#endregion



func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch:
		if !event.pressed:
			input.emit(self)
func _on_body_entered(body):
	if body.get_tag() == "Player":
		activate_neighbors()
func _on_body_exited(body):
	if body.get_tag() == "Player":
		disactivate_neighbors()
