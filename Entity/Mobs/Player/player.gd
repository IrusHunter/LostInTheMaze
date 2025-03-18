class_name Player
extends CharacterBody2D

#region fields
const path: String = "res://Entety/Mobs/Player/player.tscn"
var _save_path: String = Global.init_unit_path
var _health: Health
var _inventory: InventoryData
var _inventory_robber: InventoryRobber
@onready var _independent_movement: IndependentMovement
var _moves: int
var _grenate_thrower: GrenateThrower
signal moves_changed
#endregion

func _ready():
	_inventory_robber = InventoryRobber.init(self, _inventory, 10)
func _init():
	_health = Health.new(100, death)
	_health.health_changed.connect(save_to_file)
	_independent_movement = IndependentMovement.new(32*150, self)
	_grenate_thrower = GrenateThrower.init(150)
static func init(
	perent: Node, position: Vector2, direction: float, damage: float, path_to_inv: String, moves: int
) -> Player:
	var p = preload(path).instantiate()
	p._inventory = InventoryData.new(path_to_inv)
	p._moves = moves
	perent.add_child(p)
	p.health.current_health -= damage
	p.position = position
	p.rotation = direction
	p.up_direction = Vector2.from_angle(direction)
	return p
static func init_from_file(file_path: String, parent: Node) -> Player:
	var pF = FileAccess.open(file_path, FileAccess.READ)
	var line = pF.get_line().split(' ', false)
	var p = Player.init(
		parent, Vector2(int(line[0]), int(line[1])) * Global.size + Vector2(Global.size / 2, Global.size / 2),
		float(line[2]), float(line[3]), file_path.get_base_dir() + '/' + pF.get_line(), int(line[4])
	)
	p._save_path = file_path
	return p

#region properties
var health: Health:
	get:
		return _health
var independent_movement: IndependentMovement:
	get:
		return _independent_movement
var inventory: InventoryData:
	get:
		return _inventory
var moves: int:
	get:
		return _moves
	set(value):
		_moves = value
		save_to_file() 
#endregion

#region metods
func save_to_file() -> void:
	var pF = FileAccess.open(_save_path, FileAccess.WRITE)
	var line: String = str(int(position.x/Global.size)) + " " + str(int(position.y/Global.size)) \
	+ " " + str(rotation) + " " + str(health.top_health-health.current_health) + " " + str(_moves)
	pF.store_line(line)
	pF.store_line(_inventory.path.get_file())
	pF.close()
	_inventory.save()
func throw_granate() -> void:
	if not _inventory.selected_item.tag == "Grenate":
		return
	var pos = position + Vector2.from_angle(rotation).orthogonal()*6
	var g = Grenate.init(get_parent(), pos, 20, 0.3)
	_inventory.selected_item.count -= 1
	_inventory.save()
	_grenate_thrower.throw_grenate(g, Vector2.from_angle(rotation))
	add_move()
func plant_bomb(_position: Vector2, bomb_parent: Node) -> void:
	_inventory.selected_item.count -= 1
	_inventory.save()
	Bomb.init(bomb_parent, _position, 105, 15, 4)
	add_move()
func death() -> void:
	_health.current_health = _health.top_health
func add_move() -> void:
	_moves += 1
	moves_changed.emit()
	save_to_file()
func move_to(pos: Vector2) -> void:
	_independent_movement.start_move(pos)
	await _independent_movement.movement_stoped
	add_move()
#endregion

