class_name StealWall
extends RigidBody2D

#region fields
const path: String = "res://Entity/Structure/Walls/StealWall/steal_wall.tscn"
var _save_path: String = Global.init_unit_path
var _health: Health
var _wall_priority: int
var _neighbors_control_module: NeighborsControlModule
@onready var _anim: StealWallAnim = $AnimatedSprite2D
@onready var _occluder: LightOccluder2D = $LightOccluder2D
#endregion\

func _ready():
	_neighbors_control_module = NeighborsControlModule.init(self, NeighborsControlModule.priorities.STEAL)
	_wall_priority = NeighborsControlModule.priorities.STEAL
func _init():
	_health = Health.new(100, death)
	_health.health_changed.connect(save_to_file)
static func init(parent: Node, position: Vector2, rotation: float, damage: float) -> StealWall:
	var sw: StealWall = preload(path).instantiate()
	parent.add_child(sw)
	sw.position = position
	sw.rotation = rotation
	sw._health.current_health -= damage
	return sw
static func init_from_file(parent: Node, file: String) -> StealWall:
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
	_occluder.occluder_light_mask = 0
#endregion
