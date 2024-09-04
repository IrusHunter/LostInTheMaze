class_name StoneWall
extends RigidBody2D

#region fields
const path: String = "res://Entety/Structure/Walls/StoneWall/stone_wall.tscn"
var _save_path: String = Global.init_unit_path
var _health: Health
var _neighbors_control_module: NeighborsControlModule
var _wall_priority: int
@onready var _anim: StoneWallAnim = $AnimatedSprite2D
#endregion\

func _ready():
	_neighbors_control_module = NeighborsControlModule.init(self, NeighborsControlModule.priorities.STONE)
	_wall_priority = NeighborsControlModule.priorities.STONE
func _init():
	_health = Health.new(10, death)
	_health.health_changed.connect(save_to_file)
static func init(parent: Node, position: Vector2, rotation: float, damage: float) -> StoneWall:
	var sw: StoneWall = preload(path).instantiate()
	parent.add_child(sw)
	sw.position = position
	sw.rotation = rotation
	sw._health.current_health -= damage
	return sw
static func init_from_file(parent: Node, file: String) -> StoneWall:
	var swf = FileAccess.open(file, FileAccess.READ)
	var line = swf.get_line().split(' ', false)
	var rotation: float
	if line[2] == "1":
		rotation = 0
	else:
		rotation = PI/2
	var sw = init(
		parent, Wall.get_position(Vector2(int(line[0]), int(line[1])), bool(int(line[2]))), rotation,
		float(line[3])
	) 
	sw._save_path = file
	return sw

#region properties
var health: Health:
	get:
		return _health
var wall_priority: int:
	get:
		return _wall_priority
var neighbors_control_module: NeighborsControlModule:
	get:
		return _neighbors_control_module
#endregion

#region metods
func save_to_file() -> void:
	var swf = FileAccess.open(_save_path, FileAccess.WRITE)
	var pos = Wall.get_tile_map_position(position)
	var rot: int
	if rotation > PI/2 - 0.2:
		rot = 0
	else:
		rot = 1
	swf.store_line(
		str(pos.x) + " " + str(pos.y) + " " + str(rot) + " " + str(_health.top_health - _health.current_health)
	)
	swf.close()
func death() -> void:
	_anim.dead = true
	collision_layer = 1
	collision_mask = 1
#endregion
