class_name WallAnim
extends AnimatedSprite2D

#region fields
var _code: int = -1
var _last_anim: String = "alive"
var _dead: bool = false
#endregion

func _ready():
	play("alive_calm0")

#region properties
var code: int:
	set(value):
		_code = value
		reset()
var dead: bool:
	get:
		return _dead
	set(value):
		if not value == _dead:
			if not _code == -1:
				_last_anim = "dead"
			else:
				death()
#endregion

#region metods
func reset() -> void:
	play(_last_anim + "_calm" + str(_code))
func death() -> void:
	_last_anim = "dead"
	play("dead" + str(code))
	await animation_finished
	play("dead_calm" + str(code))
#endregion
