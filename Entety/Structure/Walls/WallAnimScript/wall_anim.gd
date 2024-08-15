class_name WallAnim
extends AnimatedSprite2D

#region fields
@onready var anim: SpriteFrames = sprite_frames
var _code: int
var _last_anim: String = "calm"
#endregion

func _ready():
	play("default")

#region properties
var code: int:
	set(value):
		_code = value
		reset()
#endregion

#region metods
func reset() -> void:
	if _last_anim == "death":
		death()
	elif anim.has_animation(_last_anim + str(_code)):
		play(_last_anim + str(_code))
	else:
		play("default")
func death() -> void:
	_last_anim = "death"
	if anim.has_animation("death" + str(_code)):
		play("death" + str(_code))
	else:
		get_parent().remove_child(self)
		queue_free()
#endregion
