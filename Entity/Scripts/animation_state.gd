class_name AnimationState
extends Node
## States for AnimationSprite2D. Represents general structure

var _name: StringName ## animation name
var _anim_sprite: AnimatedSprite2D ## animation sprite for control
var _next_state: AnimationState ## next animation state after ending of current animation
## returns the next animation state or null if current animation should play. Signature: [br][br]
## [gdscript]func func_next_state() -> AnimationState[/gdscript]
var _func_next_state: Callable 

## [b]parent[/b] - parent for node[br]
## [b]anim_name[/b] - to play animation name[br]
## [b]anim_sprite[/b] - animation sprite for control[br]
## [b]func_next_state[/b] - [member _func_next_state]
static func init(
parent: Node, anim_name: StringName, anim_sprite: AnimatedSprite2D, func_next_state: Callable
) -> AnimationState:
	var anim_s := AnimationState.new()
	parent.add_child(anim_s)
	anim_s._anim_sprite = anim_sprite
	anim_s._func_next_state = func_next_state
	anim_s._name = anim_name
	return anim_s

## activates Node (the AnimationState) [br]
## DON'T FORGET TO DISACTIVATE PREVIOUS ANIMATIONSTATE!!! [br]
## [b]frame[/b] - index of start frame (0 by default) [br]
## [b]progress[/b] - percentage of frame screen time (0 by default) [br]
func activate(frame: int = 0, progress: float = 0.0) -> void:
	_anim_sprite.animation_looped.connect(_switch_state)
	_anim_sprite.animation_finished.connect(_switch_state)
	
	_anim_sprite.play(_name)
	_anim_sprite.set_frame_and_progress(frame, progress)
	_next_state = null
	process_mode = Node.PROCESS_MODE_INHERIT

## disactivates Node (the AnimationState) [br]
## DON'T FORGET TO ACTIVATE NEXT ANIMATIONSTATE!!! [br]
func disactivate() -> void:
	_anim_sprite.animation_looped.disconnect(_switch_state)
	_anim_sprite.animation_finished.disconnect(_switch_state)
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	if _next_state == null:
		_next_state = _func_next_state.call()

## Activates when animation is end. [br]
## If [member _next_state] is null, doesn't change the state
func _switch_state() -> void:
	if _next_state != null:
		disactivate()
		_next_state.activate()

## Immediately changes the state to new_state. [br]
## [b]new_state[/b] - the next state[br]
## [b]frame[/b] -  index of start frame (current frame by default)[br]
## [b]progress[/b] - percentage of frame screen time (current progress by default)[br]
func switch_state_hard(
new_state: AnimationState, frame: int = _anim_sprite.frame, progress: float = _anim_sprite.frame_progress
):
	disactivate()
	new_state.activate(frame, progress)
