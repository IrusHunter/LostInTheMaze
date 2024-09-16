class_name EnvironmentMove

class EnvMoveControl:
	var metods: Array[Callable] = []
	var current_move: int = 0
	
	func _init():
		pass
	
	func add_move(f: Callable):
		metods.append(f)
	func remove_move(f: Callable):
		var p = metods.find(f)
		if current_move > p:
			current_move -= 1
		metods.remove_at(p)
	func next_move() -> bool:
		if metods.size() <= current_move:
			current_move = 0
			return false
		await metods[current_move].call()
		current_move += 1
		return true

#region properties
static var _moves: Array[EnvMoveControl]
static var _current_group: int = 0
enum groups{RIVERS = 0, BOMBS = 1}  
#endregion

static func _static_init():
	for i in range(2):
		_moves.append(EnvMoveControl.new())
func _init(group: int, env_move: Callable):
	_moves[group].add_move(env_move)
static func init(group: int, env_move: Callable) -> EnvironmentMove:
	return EnvironmentMove.new(group, env_move)

#region metods
static func next_env_move() -> void:
	while not _moves.size() == _current_group:
		if not await _moves[_current_group].next_move():
			_current_group += 1
	_current_group = 0
	#if _moves.size() == _current_group:
		#_current_group = 0
	#else:
		#if not await _moves[_current_group].next_move():
			#_current_group += 1
		#next_env_move()
func remove_move(group: int, env_move: Callable) -> void:
	_moves[group].remove_move(env_move)
static func clear() -> void:
	_moves.clear()
	_static_init()
#endregion

