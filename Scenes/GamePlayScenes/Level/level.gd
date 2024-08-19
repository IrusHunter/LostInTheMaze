class_name Level
extends Node2D

var _level_file_path = Global.saves_path + Global.game_name + "/Levels/" + Global.current_level + "/"
const path: String = "res://Scenes/GamePlayScenes/Level/level.tscn"

#region level data
@onready var _ui: Panel = $CanvasLayer/Panel
@onready var _map: TileMap = $TileMap
@onready var _camera: Camera2D = $MainCamera
@onready var _extra_camera: Camera2D = $ExtraCamera
var _level_started_yet: int = 0
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
	if not FileAccess.file_exists(Global.tmp_level_path + "main.txt"):
		Global.copy_dirs(
			_level_file_path, Global.tmp_level_path
		)
	_ui.visible = false
	_extra_camera.zoom /= 4
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
#region initializating inventory
	if not _level_started_yet:
		Global.copy_files(
			Global.saves_path + Global.game_name + "/inventory.txt", 
			Global.tmp_level_path + "Player/inventory.txt"
		)
	_player = Player.init_from_file(Global.tmp_level_path + "Player/main.txt", _players)
	_player.independent_movement.movement_stoped.connect(next_move)
	_inventory = Inventory.init(_ui, _player.inventory, Vector2(20, 176), 4)
#endregion
#region initializating tile map
	var tmf = FileAccess.open(Global.tmp_level_path + "Config/tilemap.txt", FileAccess.READ)
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
	tmf = FileAccess.open(Global.tmp_level_path + "Config/tilemap.txt", FileAccess.READ)
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
	Exit.init_exits(_exits, Global.tmp_level_path + "Config/Plains/Exits/", tap_on_exit)
	Wall.init_walls(_walls, Global.tmp_level_path + "Config/Structure/Walls/")
	Chest.init_chests(_chests, Global.tmp_level_path + "Config/Structure/Chests/")
	River.init_from_dir(_rivers, Global.tmp_level_path + "Config/Plains/Rivers")
	
	_camera.position = _player.position
	_ui.visible = true
	_level_started_yet = 1

func next_move():
	EnvironmentMove.next_env_move()
	_moves += 1
	$CanvasLayer/Panel/movesLabel.text = tr("labelLevelMoves") + ": " + str(_moves)
	save_main_file()


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
		_ui.hide()
		_extra_camera.enabled = true
		_camera.enabled = false
		await RenderingServer.frame_post_draw
		
		var viewport = _extra_camera.get_viewport()
		var img = viewport.get_texture().get_image()
		img.save_png(_level_file_path + "texture.png")
		_extra_camera.enabled = false
		_camera.enabled = true
		
		var prev_inv := InventoryData.init(Global.saves_path + Global.game_name + "/inventory.txt")
		for i: ItemData in _player.inventory.items:
			var tmp_i := ItemData.new()
			tmp_i.fill(i)
			tmp_i.count *= -1
			prev_inv.add_item(tmp_i)
			if tmp_i.count != 0:
				prev_inv.add_new_item(tmp_i)
		var get_inv := InventoryData.init("")
		var spent_inv := InventoryData.init("")
		for i: ItemData in prev_inv.items:
			if i.count > 0:
				spent_inv.add_new_item(i)
			elif i.count < 0:
				i.count *= -1
				get_inv.add_new_item(i)
		
		var eoln = EndOfLevelNotification.init(
			$CanvasLayer, Global.current_level, _moves, get_inv, spent_inv, _level_file_path + "texture.png"
		)
		await eoln.time_to_continue
		#save_level()
#endregion

#control gameplay at the Level
func _input(event):	
	# work with gamemenu
	if $CanvasLayer/GameMenu.visible:
		return
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_camera.zoom *= 1.2
				# call the zoom function
			# zoom out
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_camera.zoom /= 1.2
				# call the zoom function
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

func save_level() -> void:
	_level_started_yet = 0
	save_main_file()
	Global.delete_files(Global.saves_path + Global.game_name + "/Levels/" + Global.current_level)
	Global.copy_dirs(Global.tmp_level_path, _level_file_path)
	Global.copy_files(_player.inventory.path, Global.saves_path + Global.game_name + "/inventory.txt")
func save_main_file() -> void:
	var mf = FileAccess.open(Global.tmp_level_path + "main.txt", FileAccess.WRITE)
	mf.store_line(str(_level_started_yet) + " " + str(_moves))
	mf.close()


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

