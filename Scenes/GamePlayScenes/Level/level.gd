class_name Level
extends Node2D

var _level_file_path = Global.saves_path + "Levels/" + Global.current_level + "/"
const path: String = "res://Scenes/GamePlayScenes/Level/level.tscn"

#region level data
@onready var _ui: Panel = $CanvasLayer/Panel
@onready var _map: TileMap = $TileMap
@onready var _camera: Camera2D = $MainCamera
var _level_started_yet = 0
#endregion
#region gameplay data
var _item_in_use = false
var _camera_in_move = false
var _drag_on_panel = false
var _moves: int = -1
#endregion
#region player data
@onready var _player: Player
@onready var _inventory: Inventory
#endregion
#region enteties data
@onready var _walls: Node = $Walls
@onready var _chests: Node = $Chests
@onready var _bombs: Node = $Bombs
@onready var _holes: Node = $Holes
@onready var _main_holes: Node = $Holes/MainHoles
@onready var _rivers: Node = $Rivers
@onready var _exits: Node = $Exits
@onready var _players: Node = $Player
#endregion

func transform_global_position_to_local(pos: Vector2) -> Vector2:
	var zC = get_viewport().get_screen_transform() * get_global_transform_with_canvas() * Vector2(0,0)
	pos -= zC / min(get_viewport().get_screen_transform().x.x, get_viewport().get_screen_transform().y.y)
	pos /= $MainCamera.zoom
	return pos
static func to_tilemap_coords(coords: Vector2) -> Vector2i:
	if coords.x<0:
		coords.x -= Global.size
	if coords.y<0:
		coords.y -= Global.size
	coords.x = int((coords.x) / Global.size)
	coords.y = int((coords.y) / Global.size)
	return Vector2i(coords)

func comunicate_with_panel(event):
	event.position -= _ui.position
	if _inventory.set_selected_slot(event.position - _inventory.position) == 10:
		_item_in_use = not _item_in_use
func _ready():
	Global.copy_dirs(_level_file_path, Global.tmp_level_path)
	_ui.visible = false
#region clearing level
	for hole in _holes.get_children():
		if hole == _main_holes: continue
		_holes.remove_child(hole)
		hole.queue_free()
	for hole in _main_holes.get_children():
		_main_holes.remove_child(hole)
		hole.queue_free()
	
	for river_tile in _rivers.get_children():
		_rivers.remove_child(river_tile)
		river_tile.queue_free()
	
	for bomb in _bombs.get_children():
		_bombs.remove_child(bomb)
		bomb.queue_free()
	
	for wall in _walls.get_children():
		_walls.remove_child(wall)
		wall.queue_free()
	
	for chest in _chests.get_children():
		_chests.remove_child(chest)
		chest.queue_free()
	
	for v in $Void.get_children():
		$Void.remove_child(v)
		v.queue_free()
	
	for exit_tile in _exits.get_children():
		_exits.remove_child(exit_tile)
		exit_tile.queue_free()
	
	_map.clear()
#endregion
#region initializating start data
	var lF = FileAccess.open(Global.tmp_level_path + "main.txt", FileAccess.READ)
	var line: PackedStringArray = lF.get_line().split(' ', false)
	_level_started_yet = int(line[0])
	_moves = int(line[1])
	line = lF.get_line().split(' ', false)
#endregion
#region initializating exits (*)
	var ef = FileAccess.open(_level_file_path + "Config/Plains/exit.txt", FileAccess.READ)
	line = ef.get_line().split(' ', false)
	ExitTile.init(
		_exits, tap_on_exit, Vector2(
			int(line[0]) * Global.size + Global.size / 2, int(line[1]) * Global.size + Global.size / 2
		)
	)
#endregion
	if not _level_started_yet:
		Global.copy_files(Global.user_path + "inventory.txt", _level_file_path + "Player/inventory.txt")
	_player = Player.init_from_file(_level_file_path + "Player/main.txt", _players)
	_player.independent_movement.movement_stoped.connect(next_move)
	_inventory = Inventory.init(_ui, _player.inventory, Vector2(20, 176), 4)
#region initializating tile map
	var tmf = FileAccess.open(_level_file_path + "Config/tilemap.txt", FileAccess.READ)
	line = tmf.get_line().split(' ', false)
	var colum: int = 0
	while line.size() != 0:
		for i in range(line.size()):
			_map.set_cell(0, Vector2i(i, colum), int(line[i]), Vector2(0,0), 0)
		colum += 1
		line = tmf.get_line().split(' ', false)
	tmf.close()
#endregion
#region initializating unbreacable walls 
	tmf = FileAccess.open(_level_file_path + "Config/tilemap.txt", FileAccess.READ)
	line = tmf.get_line().split(' ', false)
	colum = 0
	while line.size() != 0:
		for i in range(line.size()):
			if _map.get_cell_source_id(0, Vector2i(i, colum - 1)) == -1:
				UnbreakableWall.init(_walls, Wall.get_position(Vector2i(i, colum), false), PI/2)
			if _map.get_cell_source_id(0, Vector2i(i - 1, colum)) == -1:
				UnbreakableWall.init(_walls, Wall.get_position(Vector2i(i, colum), true), 0)
			if _map.get_cell_source_id(0, Vector2i(i, colum + 1)) == -1:
				UnbreakableWall.init(_walls, Wall.get_position(Vector2i(i, colum + 1), false), PI/2)
			if _map.get_cell_source_id(0, Vector2i(i + 1, colum)) == -1:
				UnbreakableWall.init(_walls, Wall.get_position(Vector2i(i + 1, colum), true), 0)
		colum += 1
		line = tmf.get_line().split(' ', false)
	tmf.close()
#endregion
#region void (*)
	#for i in range(width):
		#line = lF.get_line().split(' ', false)
		#Global.p = 0
		#for j in range(length):
			#if int(line[j]):
				#var voidTile = voidTilePreload.instantiate()
				#voidTile.position = Vector2(j*size+ size/2, i*size + size/2)
				#$Void.add_child(voidTile)
#endregion
	Wall.init_walls(_walls, _level_file_path + "Config/Structure/Walls/")
	Chest.init_chests(_chests, _level_file_path + "Config/Structure/Chests/")
	River.init_from_dir(_rivers, _level_file_path + "Config/Plains/Rivers")
	
	_camera.position = _player.position
	_ui.visible = true
	_level_started_yet = 1

func next_move():
	EnvironmentMove.next_env_move()
	_moves += 1
	$CanvasLayer/Panel/movesLabel.text = "Moves: " + str(_moves)

#region gameplay
func player_death():
	if _player.independent_movement.on_move: 
		_player.independent_movement.stop_move()
	for e in _exits.get_children():
		_player.position = e.positiond
func tap_on_hole(hole: Hole):
	if hole.get_is_active():
		_player.position = hole.position
		next_move()
func tap_on_exit(exit_tile: ExitTile):
	if Level.to_tilemap_coords(_player.position) == Level.to_tilemap_coords(exit_tile.position):
		_on_return_to_lobby_button_pressed()
#endregion

#control gameplay at the Level
func _input(event):	
	# work with gamemenu
	if $CanvasLayer/GameMenu.visible:
		return
	
	#if $tmpForCamera.visible:
		#if event is InputEventScreenDrag:
			#if event.position.x < $CanvasLayer/Panel.position.x:
				#$MainCamera.position -= event.relative/$MainCamera.zoom.x
		#return
	
	if event is InputEventScreenTouch:
		if (event.position.x > _ui.position.x) and !event.pressed:
			if not _camera_in_move and  not _drag_on_panel:
				comunicate_with_panel(event)
				return
	
	if _item_in_use:
		match(_inventory.selected_slot.data.tag):
#region using Grenate (*)
			"Grenate":
				if event is InputEventScreenDrag:
					event.position = transform_global_position_to_local(event.position)
					var dir: Vector2 = -(_player.position - event.position)
					_player.rotation = dir.angle() + PI/2
				elif event is InputEventScreenTouch:
					if not event.pressed:
						_item_in_use = 0
						#setGrenate(20, 0.3)
						_player.throw_granate()
						#$CanvasLayer/Panel/Inventory.selectedSlot.itemCount -= 1
						next_move()
#endregion
#region using Bomb (*)
			"Bomb":
				if event is InputEventScreenTouch:
					event.position = transform_global_position_to_local(event.position)
					var delta_coords = abs(
						Level.to_tilemap_coords(_player.position) - Level.to_tilemap_coords(event.position)
					)
					if delta_coords.x == 0 && delta_coords.y == 0:
						_player.plant_bomb(event.position, _bombs)
						_item_in_use = 0
						next_move()
#endregion
		return
#region changing camera position
	if event is InputEventScreenDrag:
		if event.position.x > _ui.position.x && !_camera_in_move:
			_drag_on_panel = 1
		if !_drag_on_panel:
			_camera_in_move = 1
			_camera.position -= event.relative / _camera.zoom.x
	if _camera_in_move || _drag_on_panel:
		if event is InputEventScreenTouch:
			if !event.pressed:
				_camera_in_move = 0
				_drag_on_panel = 0
		return
#endregion
	
	if (not (event is InputEventScreenTouch) or _player.independent_movement.on_move):
		return
	if event.pressed:
		return
	
	event.position = transform_global_position_to_local(event.position)
	var event_tile_position = Level.to_tilemap_coords(event.position)
	var delta_coords = abs(Level.to_tilemap_coords(_player.position) - event_tile_position)
	if (not delta_coords.x == 0 or delta_coords.y > 1) and (delta_coords.x > 1 or not delta_coords.y == 0):
		return
#region tap behind players cell (player's movement)
	if (not delta_coords.x == 0 or not delta_coords.y == 0):
		event_tile_position.x = event_tile_position.x * Global.size + Global.size / 2
		event_tile_position.y = event_tile_position.y * Global.size + Global.size / 2
		_player.independent_movement.start_move(event_tile_position)
		return
#endregion

#func saveLevel():
	##saveLevel
	#var lF = FileAccess.open(levelFilePath+Global.currentLevel+".txt", FileAccess.WRITE)
	#lF.store_line(str(levelStartedYet) + " " + str(moves))
	#var line
	#
	#lF.store_line(str(length) + " " + str(width))
	#
##region saving count of enteties (-)
	##var nArsenals = $Arsenals.get_child_count()
	#var nChests = chests.get_child_count()
	#var nRivers = rivers_data.size()
	#var nBombs = bombs.get_child_count()
	#var nHoles = main_holes.get_child_count()
	#lF.store_line(str(nChests) + " " + str(nRivers) + " " + str(nBombs) + " " + str(nHoles))
##endregion
##region saving exits data
	#for e: ExitTile in exits.get_children():
		#line = str(int(e.position.x/size)) + " " + str(int(e.position.y/size))
	#lF.store_line(line)
##endregion
	#player.save_to_file(levelFilePath + "Config/Player.txt")
##region saving tile map (-)
	#var arr = []
	##save TileMap
	#arr = arr2Set(arr)
	#for i in range(width):
		#line = ""
		#for j in range(length):
			#line += str(map.get_cell_source_id(0, Vector2(j,i))) + " "
		#lF.store_line(line)
	#
	#for voidTile in $Void.get_children():
		#if int(voidTile.position.x)%size == int(voidTile.position.y)%size:
			#var tmpVector2 = toTilemapCoords(voidTile.position)
			#arr[tmpVector2.y][tmpVector2.x] += 1
	#for i in range(width):
		#line = ""
		#for j in range(length):
			#line += str(arr[i][j]) + " "
		#lF.store_line(line)
##endregion
##region saving walls data
	##save horizontal Walls
	#for i in range(width + 1):
		#for j in range(length*2):
			#arr[i][j] = 0
	#for voidTile in $Void.get_children():
		#if (int(voidTile.position.x)%size == 16) && (int(voidTile.position.y)%size == 0):
			#arr[int(voidTile.position.y/size)][int((voidTile.position.x)/size)*2] += 10000
	#for wall: Wall in walls.get_children():
		#if (int(wall.position.x)%size == 16) && (int(wall.position.y)%size == 0):
			#arr[int(wall.position.y/size)][int((wall.position.x)/size)*2] += wall.type
			#arr[int(wall.position.y/size)][int((wall.position.x)/size)*2+1] += \
			#wall.get_top_health_points() - wall.get_health_points()
	#for i in range(width + 1):
		#line = ""
		#for j in range(length*2):
			#line += str(arr[i][j]) + " "
		#lF.store_line(line)
	##save wertical Walls
	#for i in range(width + 1):
		#for j in range(length*2 + 2):
			#arr[i][j] = 0
	#for voidTile in $Void.get_children():
		#if (int(voidTile.position.y)%size == 16) && (int(voidTile.position.x)%size == 0):
			#arr[int(voidTile.position.y/size)][int((voidTile.position.x)/size)*2] += 10000
	#for wall: Wall in walls.get_children():
		#if (int(wall.position.y)%size == 16) && (int(wall.position.x)%size == 0):
			#arr[int(wall.position.y/size)][int((wall.position.x)/size)*2] += wall.type
			#arr[int(wall.position.y/size)][int((wall.position.x)/size)*2 + 1] += \
			#wall.get_top_health_points() - wall.get_health_points()
	#for i in range(width):
		#line = ""
		#for j in range(length*2 + 2):
			#line += str(arr[i][j]) + " "
		#lF.store_line(line)
##endregion
##region saving chests
	#for chest: Chest in chests.get_children():
		#var tmpPos = toTilemapCoords(chest.position)
		#lF.store_line(str(tmpPos.x) + " " + str(tmpPos.y) + " " + str(int(chest.rotation/PI*2+0.2)) + " " +\
		 #str(chest.type) + " " + str(chest.get_number_of_key()) + " " + str(chest.get_top_health_points() -\
		 #chest.get_health_points())) 
		#line = chest.get_inventory_path().split('/',false)
		#line = line[line.size()-1]
		#lF.store_line(line)
##endregion
##region saving bombs
	#for bomb: Bomb in bombs.get_children():
		#lF.store_line(str(bomb.position.x) + " " + str(bomb.position.y) + " " + str(bomb.data.get_life_time()))
##endregion
##region saving rivers
	#for r: River in rivers_data:
		#line = str(r.get_speed())
		#var rt = r.get_origin()
		#while rt != null:
			#line += " " + str(rt.position.x / size) + " " + str(rt.position.y / size)
			#rt = rt.get_next()
		#lF.store_line(line)
##endregion
##region saving holes
	#for h: Hole in main_holes.get_children():
		#line = ""
		#while h != null:
			#line += str(int(h.position.x/size)) + " " + str(int(h.position.y/size)) + " "
			#h = h.get_next()
		#lF.store_line(line)
##endregion
	#
	#lF.close()

func _on_menu_button_pressed():
	$CanvasLayer/GameMenu.show()

##GameMenu Script here
func _on_continiune_button_pressed():
	$CanvasLayer/GameMenu.hide()
func _on_options_button_pressed():
	$CanvasLayer/GameMenu/Options.show()
func _on_return_to_lobby_button_pressed():
	get_tree().change_scene_to_file(Lobby.path)
func _on_return_to_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/UserInterface/Menus/MainMenu.tscn")

func _process(delta):
	#print($Player.NOTIFICATION_PROCESS)
	$CanvasLayer/Panel/FPSCounter.text = str(1/delta)
	if float($CanvasLayer/Panel/FPSCounter2.text) < 1/delta:
		$CanvasLayer/Panel/FPSCounter2.text = str(1/delta)
	pass
	#if $tmpForCamera.visible:
		#$MainCamera.zoom.x = $CanvasLayer/Panel/HSlider.value
		#$MainCamera.zoom.y = $CanvasLayer/Panel/HSlider.value
	#if itemInUse:
		##$CanvasLayer/Panel/Inventory.sslot.play("InUse")
		#$CanvasLayer/Panel/Inventory.sslot.modulate.g=0
		#$CanvasLayer/Panel/Inventory.sslot.modulate.b=0
	#else:
		##$CanvasLayer/Panel/Inventory.sslot.play("Default")
		#$CanvasLayer/Panel/Inventory.sslot.modulate.g=1
		#$CanvasLayer/Panel/Inventory.sslot.modulate.b=1

