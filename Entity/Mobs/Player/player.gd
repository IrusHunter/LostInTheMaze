class_name Player
extends CharacterBody2D

#region fields
const PATH: String = "res://Entity/Mobs/Player/player.tscn"
const PIXELS_PER_METER = 8
#var _save_path: String = Global.init_unit_path
var _health: Health
var _inventory: InventoryData
var _inventory_robber: InventoryRobber
var _moves: int
var _grenate_thrower: GrenateThrower
signal moves_changed

var _anim_states: Dictionary[StringName, AnimationState] = {}
@onready var _move_unit: MoveUnit
@onready var _anim: AnimatedSprite2D = $AnimatedSprite2D
#endregion
var _data_saver: DataSaver

#region constructor and save
func _ready():
	_anim_states["idle"] = AnimationState.init(_anim, "idle", _anim, _from_idle_anim)
	_anim_states["walk_left"] = AnimationState.init(_anim, "walk_left", _anim, _from_walk_left_anim)
	_anim_states["walk_right"] = AnimationState.init(_anim, "walk_right", _anim, _from_walk_right_anim)
	
	_anim_states["idle"].activate()
	pass
func _init():
	#_health = Health.new(100, death)
	#_health.health_changed.connect(save_to_file)
	#_independent_movement = IndependentMovement.new(32*150, self)
	#_grenate_thrower = GrenateThrower.init(150)
	pass
static func init(parent: Node) -> Player:
	var p := preload(PATH).instantiate()
	parent.add_child(p)
	
	p._move_unit = MoveUnit.new(0, 4*Level.PIXELS_PER_METER*60, p)
	p._move_unit.direction_changed.connect(p.move_in)
	
	return p
#static func init(
	#perent: Node, position: Vector2, direction: float, damage: float, path_to_inv: String, moves: int
#) -> Player:
	#var p = preload(path).instantiate()
	#p._inventory = InventoryData.new(path_to_inv)
	#p._moves = moves
	#perent.add_child(p)
	#p.health.current_health -= damage
	#p.position = position
	#p.rotation = direction
	#p.up_direction = Vector2.from_angle(direction)
	#return p
#static func init_from_file(file_path: String, parent: Node) -> Player:
	#var pF = FileAccess.open(file_path, FileAccess.READ)
	#var line = pF.get_line().split(' ', false)
	#var p = Player.init(
		#parent, Vector2(int(line[0]), int(line[1])) * Global.size + Vector2(Global.size / 2, Global.size / 2),
		#float(line[2]), float(line[3]), file_path.get_base_dir() + '/' + pF.get_line(), int(line[4])
	#)
	#p._save_path = file_path
	#return p
#endregion

#region properties
var move_unit: MoveUnit:
	get:
		return _move_unit
var health: Health:
	get:
		return _health
#endregion

#region metods
func move_in(d: Vector2) -> void:
	#rotation = d.angle()
	pass
#func throw_granate() -> void:
	#if not _inventory.selected_item.tag == "Grenate":
		#return
	#var pos = position + Vector2.from_angle(rotation).orthogonal()*6
	#var g = Grenate.init(get_parent(), pos, 20, 0.3)
	#_inventory.selected_item.count -= 1
	#_inventory.save()
	#_grenate_thrower.throw_grenate(g, Vector2.from_angle(rotation))
	#add_move()
#func plant_bomb(_position: Vector2, bomb_parent: Node) -> void:
	#_inventory.selected_item.count -= 1
	#_inventory.save()
	#Bomb.init(bomb_parent, _position, 105, 15, 4)
	#add_move()
#func death() -> void:
	#_health.current_health = _health.top_health
#endregion

#region animation
func _from_idle_anim() -> AnimationState:
	if !move_unit.on_move:
		return null
	
	var a := velocity.angle()
	if abs(a) <= PI/2:
		return _anim_states["walk_right"]
	else:
		return _anim_states["walk_left"]
func _from_walk_right_anim() -> AnimationState:
	if !move_unit.on_move:
		return _anim_states["idle"]
	
	if abs(velocity.angle()) > PI/2:
		_anim_states["walk_right"].switch_state_hard(_anim_states["walk_left"])
	
	return null
func _from_walk_left_anim() -> AnimationState:
	if !move_unit.on_move:
		return _anim_states["idle"]
	
	if abs(velocity.angle()) < PI/2:
		_anim_states["walk_left"].switch_state_hard(_anim_states["walk_right"])
	
	return null

#endregion
