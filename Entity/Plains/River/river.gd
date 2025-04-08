class_name River

class DataForControl:
	var body: Node
	var steps: int
	var tile: RiverTile
	func _init(_body: Node, _steps: int, _tile: RiverTile):
		body = _body
		steps = _steps
		tile = _tile
	static func init(body: Node, steps: int, tile: RiverTile) -> DataForControl:
		return DataForControl.new(body, steps, tile)

#region fields
var _origin: RiverTile
var _environment_move: EnvironmentMove
var _bodies_mover: BodiesMover
var _speed: int #tiles per move
var _save_path: String = Global.init_unit_path
var _control_the_speed: Array[DataForControl] = []
#endregion

func _init(parent: Node, speed: int, stream: Array):
	_environment_move = EnvironmentMove.init(EnvironmentMove.groups.RIVERS, activate)
	_bodies_mover = BodiesMover.init(speed)
	_speed = speed
	var previous: RiverTile = null
	for pos: Vector2 in stream:
		var rt = RiverTile.init(parent, pos, previous)
		if previous == null: 
			_origin = rt
		previous = rt
		rt.new_body.connect(body_entered)
static func init(parent: Node, speed: int, stream: Array) -> River:
	return River.new(parent, speed, stream)
static func init_from_file(parent: Node, file: String) -> River:
	var rf = FileAccess.open(file, FileAccess.READ)
	var line = rf.get_line().split(' ', false)
	var speed = int(line[0])
	line = rf.get_line().split(' ', false)
	var stream = []
	for i in range(0, line.size(), 2):
		stream.append(Vector2(int(line[i]), int(line[i+1])) * Global.size + Vector2(1,1) * Global.size/2)
	var r = River.init(parent, speed, stream)
	r._save_path = file
	return r

#region properties
#endregion

#region metods
func body_entered(river_tile: RiverTile, body) -> void:
	var dfc = find_body(body)
	if dfc == null:
		dfc = DataForControl.new(body, _speed, river_tile)
		_control_the_speed.append(dfc)
	dfc.tile = river_tile
	if dfc.steps < _speed:
		if river_tile.next_position == Vector2(-1, -1):
			if not body.get("health") == null:
				body.health.current_health = -1
			else:
				body.get_parent().remove_child(body)
				body.queue_free()
		else: 
			_bodies_mover.move_body_to(body, river_tile.next_position)
			dfc.steps += 1
func find_body(body: Node) -> DataForControl:
	for dfc: DataForControl in _control_the_speed:
		if dfc.body == body:
			return dfc
	return null
func reset_control() -> void:
	for dfc in _control_the_speed:
		dfc.steps = 0
func activate() -> void:
	reset_control()
	for dfc in _control_the_speed:
		if dfc.tile.overlaps_body(dfc.body): 
			body_entered(dfc.tile, dfc.body)
		else:
			_control_the_speed.remove_at(_control_the_speed.find(dfc))
#func all_bodies_were_moved() -> bool:
	#for dfc in _control_the_speed:
		#if dfc.steps < _speed:
			#return false
	#return true
#endregion
