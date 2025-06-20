class_name Grenate
extends RigidBody2D

#region fields
var _health: Health
const path: String = "res://Entity/Items/Grenate/grenate.tscn"
@onready var _anim = $AnimatedSprite2D
var _detonator: Detonator
var _life_time: float = 0.3
#endregion


func _ready():
	await get_tree().create_timer(_life_time,1).timeout
	_health.current_health = -1
func _init():
	#_health = Health.new(1, death)
	pass
static func init(
	parent: Node, position: Vector2, damage: float, life_time: float, radius: float = 7
) -> Grenate:
	var g: Grenate = preload(path).instantiate()
	g._life_time = life_time
	parent.add_child(g)
	g.position = position
	g._detonator = Detonator.init(g, damage, radius)
	#g.add_child(g.detonator.main_area)
	return g

#region properties
var health: Health:
	get:
		return _health
#endregion

#region metods
func death() -> void:
	freeze = true
	await _detonator.explose()
	#main_b.get_parent().remove_child(main_b)
	get_parent().remove_child(self)
	queue_free()
#endregion
