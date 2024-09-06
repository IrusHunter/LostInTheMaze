class_name Detonator
extends Node2D

#region fields
const path := "res://Damager/SplashDamager/Detonator/detonator.tscn"
var _splash_damager: SplashDamager
@onready var _detonator: Sprite2D = $Sprite2D
#endregion

func _ready():
	_detonator.hide()
static func init(parent: Node, damage: float, radius: float) -> Detonator:
	var d: Detonator = preload(path).instantiate()
	parent.add_child(d)
	d._splash_damager = SplashDamager.init(d, damage, radius)
	d._detonator.scale *= radius
	return d

#region metods
func explose() -> void:
	_splash_damager.explose()
	_detonator.show()
	await get_tree().create_timer(0.3).timeout
#endregion
