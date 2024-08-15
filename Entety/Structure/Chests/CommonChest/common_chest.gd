class_name CommonChest
extends RigidBody2D

#region fields
const path: String = "res://Entety/Structure/Chests/CommonChest/common_chest.tscn"
var _health: Health
var _free_inventory: FreeInventory
var _new_item_generator: NewItemGenerator
var _save_path: String = Global.init_unit_path
var _death_from_load: bool = false
@onready var _anim: CommonChestAnim = $AnimatedSprite2D
@onready var _collision_chape: CollisionShape2D = $CollisionShape2D
#endregion

func _ready():
	_new_item_generator = NewItemGenerator.init(get_parent(), Vector2(-1000_000, -1000_000), _free_inventory)
	_anim.clear = _free_inventory.is_clear()
func _init():
	_health = Health.new(120, death)
static func init(
	parent: Node, position: Vector2, rotation: float, inventory_path: String, opened: bool, damage: float
) -> CommonChest:
	var cc: CommonChest = preload(path).instantiate()
	cc._free_inventory = FreeInventory.new(inventory_path)
	parent.add_child(cc)
	if cc._health.current_health <= damage:
		cc._death_from_load = true
	cc._health.current_health -= damage
	cc.position = position
	cc._new_item_generator.position = cc.position + Vector2(0, -16)
	cc.rotation = rotation
	cc._anim.opened = opened
	return cc
static func init_from_file(parent: Node, file: String) -> CommonChest:
	var ccf = FileAccess.open(file, FileAccess.READ)
	var line = ccf.get_line().split(' ', false)
	var rotation = int(line[2]) * PI/2
	var inv = file.get_base_dir() + '/' + ccf.get_line()
	var cc = init(
		parent, Vector2(int(line[0]), int(line[1])) * Global.size + Vector2(Global.size / 2, Global.size / 2),
		rotation, inv, bool(int(line[3])), float(line[4])
	)
	cc._save_path = file
	ccf.close()
	return cc

#region properties
var health: Health:
	get:
		return _health
var free_inventory: FreeInventory:
	get:
		return _free_inventory
#endregion

#region metods
func death():
	if not _death_from_load:
		for i in _free_inventory.items:
			i.count = (i.count + 2) / 3
		_free_inventory.save()
	_collision_chape.set_deferred("disabled", true)
	_anim.dead = true
func save_to_file() -> void:
	var ccf = FileAccess.open(_save_path, FileAccess.WRITE)
	ccf.store_line(
		str(int(position.x / Global.size)) + " " + str(int(position.y / Global.size)) + " " + 
		str(int((rotation + 0.2)/PI*2)) + " " + str(_health.top_health - _health.current_health)
	)
	ccf.store_line(_free_inventory.path.get_file())
#endregion

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch:
		if !event.pressed:
			if _free_inventory.time_to_rob.get_connections().size() > 0:
				_anim.opened = true
				await _new_item_generator.start_creating_new_items()
				_anim.clear = _free_inventory.is_clear()
