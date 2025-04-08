class_name Bomb
extends RigidBody2D

#region fields
const path: String = "res://Entity/Items/Bomb/bomb.tscn"
var _save_path := Global.init_unit_path
var _health: Health
var _environment_move: EnvironmentMove
var _detonator: Detonator
var _life_time: int
#endregion

func _ready():
	pass
func _init():
	_health = Health.new(1, death)
	_environment_move = EnvironmentMove.new(EnvironmentMove.groups.BOMBS, reduce_life_time)
static func init(parent: Node, position: Vector2, damage: float, radius: float, life_time: int) -> Bomb:
	var b: Bomb = preload(path).instantiate()
	b._life_time = life_time
	parent.add_child(b)
	b.position = position
	b._detonator = Detonator.init(b, damage, radius)
	b._save_path = Bombs.save_dir + "Bomb_" + str(position.x) + "_" + str(position.y) + ".txt"
	return b
static func init_from_file(parent: Node, file_path: String) -> Bomb:
	var bF = FileAccess.open(file_path, FileAccess.READ)
	var line = bF.get_as_text().split(' ', false)
	var b = init(parent, Vector2(float(line[0]), float(line[1])), float(line[2]), float(line[3]), int(line[4]))
	b._save_path = file_path
	return b

#region properties
var health: Health:
	get:
		return _health
#endregion

#region metods
func reduce_life_time() -> void:
	_life_time -= 1
	save_to_file()
	if _life_time <= 0:
		_health.current_health = -1
func save_to_file() -> void:
	var bF = FileAccess.open(_save_path, FileAccess.WRITE)
	bF.store_line( 
		str(position.x) + " " + str(position.y) + " " + str(_detonator.splash_damager.damager.damage) + 
		" " + str(_detonator.splash_damager.radius) + " " + str(_life_time)
	)
	bF.close()
func death() -> void:
	_environment_move.remove_move(EnvironmentMove.groups.BOMBS, reduce_life_time)
	freeze = true
	DirAccess.remove_absolute(_save_path)
	await _detonator.explose()
	get_parent().remove_child(self)
	queue_free()
#endregion
