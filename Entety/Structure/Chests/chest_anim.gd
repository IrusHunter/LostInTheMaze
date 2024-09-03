class_name ChestAnim
extends AnimatedSprite2D

#region fields
var _opened: bool = false
var _clear: bool = false
var _dead: bool = false
#endregion

func _ready():
	play("untouchable_calm")

#region properties
var opened: bool:
	get:
		return _opened
	set(value):
		#if is_playing():
			#await animation_looped or animation_finished
			#pause()
		if not value == _opened:
			if not _dead:
				if not _opened:
					play("opening")
					await animation_finished
					play("full_calm")
				#else:
					#play("clearing_full")
					#await animation_finished
					#play("clear_calm")
		_opened = value
var clear: bool:
	get:
		return _clear
	set(value):
		#if is_playing():
			#await animation_looped or animation_finished
			#pause()
		if not value == _clear:
			if not _clear:
				_opened = true
				_clear = value
				if not _dead:
					play("clearing_full")
					await animation_finished
					play("clear_calm")
				else:
					play("clearing_full_dead")
					await animation_finished
					play("clear_dead_calm")
		_clear = value
var dead: bool:
	get:
		return _dead
	set(value):
		#if is_playing():
			#await animation_looped or animation_finished
			#pause()
		if not value == _dead:
			if not _dead:
				_dead = value
				if _opened:
					if _clear:
						play("clear_dead")
						await animation_finished
						play("clear_dead_calm")
					else:
						play("full_dead")
						await animation_finished
						play("full_dead_calm")
				else:
					play("untouchable_dead")
					await animation_finished
					play("full_dead_calm")
		_dead = value
#endregion

#region metods
#endregion
