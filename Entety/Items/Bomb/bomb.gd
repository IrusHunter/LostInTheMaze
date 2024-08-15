class_name Bomb
extends RigidBody2D

#region fields
const path: String = "res://Entety/Items/Bomb/bomb.tscn"
var _heath: Health
var _environment_move: EnvironmentMove
var _detonator: SplashDamager
var _life_time: int
signal end_env_move
#endregion

func _ready():
	pass
func _init():
	_heath = Health.new(1, death)
	_environment_move = EnvironmentMove.new(end_env_move, EnvironmentMove.groups.BOMBS, reduce_life_time)
static func init(parent: Node, position: Vector2, damage: float, radius: float, life_time: int) -> Bomb:
	var b: Bomb = preload(path).instantiate()
	b._life_time = life_time
	parent.add_child(b)
	b.position = position
	b._detonator = SplashDamager.init(b, damage, radius)
	return b
static func init_from_file(parent: Node, file_path: String) -> void:
	var bF = FileAccess.open(file_path, FileAccess.READ)
	var lines = bF.get_as_text().split('\n', false)
	for line: String in lines:
		init(parent, Vector2(float(line[0]), float(line[1])), float(line[2]), float(line[3]), int(line[4]))
static func save_to_file(parent: Node, file_path: String) -> void:
	var bF = FileAccess.open(file_path, FileAccess.WRITE)
	for b: Bomb in parent.get_children():
		var line = str(b.position.x) + " " + str(b.position.y) + " " + str(b._detonator.damager.damage) + \
		" " + str(b._detonator._radius) + " " + str(b._life_time)
		bF.store_line(line)
	bF.close()

#region properties
var health: Health:
	get:
		return _heath
#endregion

#region metods
func reduce_life_time() -> void:
	_life_time -= 1
	if _life_time <= 0:
		_heath.current_health = -1
	end_env_move.emit()
func death() -> void:
	_environment_move.remove_move(EnvironmentMove.groups.BOMBS, reduce_life_time)
	_detonator.explosion()
	get_parent().remove_child(self)
	queue_free()
#endregion













