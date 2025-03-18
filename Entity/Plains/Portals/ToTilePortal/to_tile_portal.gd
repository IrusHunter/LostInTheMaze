class_name ToTilePortal
extends Area2D

#region fields
const path: String = "res://Entity/Plains/Portals/ToTilePortal/to_tile_portal.tscn"
var _next: ToTilePortal
var _previous: ToTilePortal
var _is_active = false
@onready var _shine: ShinyToTilePortal
var _units: Array[Node2D] = []
var _to_tile_teleporter: ToTileTeleporter
#endregion

func _ready():
	_to_tile_teleporter = ToTileTeleporter.init()
func _init():
	pass
static func init(parent: Node, position: Vector2, previous: ToTilePortal = null) -> ToTilePortal:
	var ttp: ToTilePortal = preload(path).instantiate()
	ttp.previous = previous
	parent.add_child(ttp)
	ttp.position = position
	ttp._shine = ShinyToTilePortal.init(position)
	return ttp
static func init_from_file(parent: Node, file: String) -> ToTilePortal:
	var ttpf = FileAccess.open(file, FileAccess.READ)
	var coords = ttpf.get_line().split(' ', false)
	var ttp: ToTilePortal = null
	for i in range(0, coords.size(), 2):
		ttp = init(
			parent, Vector2(int(coords[i]) * Global.size, int(coords[i + 1]) * Global.size) + 
			Vector2(0.5, 0.5) * Global.size, ttp
		)
	return ttp.first_ttp

#region properties
var first_ttp: ToTilePortal:
	get:
		var current: ToTilePortal = self
		while current.previous != null: 
			current = current.previous
		return current
var previous: ToTilePortal:
	get:
		return _previous
	set(value):
		_previous = value
		if value != null: 
			value._next = self
var next: ToTilePortal:
	get:
		return _next
	set(value):
		_next = value
		if value != null: 
			value._previous = self
var is_active: bool:
	get:
		return _is_active
	set(value):
		_is_active = value
		_shine.visible = value
var units: Array[Node2D]:
	get:
		return _units
#endregion

#region metods
func activate_neighbors() -> void:
	if _next != null: 
		_next.is_active = true
	if _previous != null: 
		_previous.is_active = true
func disactivate_neighbors() -> void:
	if _next != null: 
		_next.is_active = false
	if _previous != null: 
		_previous.is_active = false
#endregion

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch:
		if !event.pressed:
			if not _is_active:
				return
			if not _previous == null:
				for b in _previous.units:
					_to_tile_teleporter.teleport_unit(b, position)
			if not _next == null:
				for b in _next.units:
					_to_tile_teleporter.teleport_unit(b, position)
func _on_body_entered(body):
	if body is Player:
		activate_neighbors()
		_units.append(body)
func _on_body_exited(body):
	if body is Player:
		disactivate_neighbors()
		_units.remove_at(_units.find(body))
