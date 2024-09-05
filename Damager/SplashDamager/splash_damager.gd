class_name SplashDamager
extends Area2D

#region fields
const path: String = "res://Damager/SplashDamager/splash_damager.tscn"
var _damager: Damager
var _radius: float
#endregion

func _ready():
	scale = Vector2(_radius, _radius)
func _init():
	_damager = Damager.new(0)
	_radius = 0
static func init(perent: Node, damage: float, radius: float) -> SplashDamager:
	var main_area: SplashDamager = preload(path).instantiate()
	main_area._damager = Damager.new(damage)
	main_area._radius = radius
	perent.add_child(main_area)
	return main_area

#region properties
var damager: Damager:
	get:
		return _damager
#endregion

#region metods
func explose():
	if get_overlapping_bodies().size() == 0:
		await body_entered
	for body in get_overlapping_bodies():
		if not body.get("health") == null:
			_damager.do_damage(body.health)
#endregion

