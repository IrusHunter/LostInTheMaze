class_name Level
extends Node2D

var _level_file_path: String #= Global.saves_path + Global.game_name + "/Levels/" + Global.current_level + "/"
var _tmp_level_path: String
const path: String = "res://Scenes/GamePlayScenes/Level/level.tscn"
const load_stages: int = 7
static var current_num_of_ls: int = 0

#region level nodes
@onready var _ui: Panel = $CanvasLayer/Panel
@onready var _map: TileMap = $TileMap
@onready var _camera: Camera2D = $MainCamera
@onready var _extra_camera: Camera2D = $ExtraCamera
@onready var _moves_label: Label = $CanvasLayer/Panel/movesLabel
#endregion
#region level data
var _level_name: String
var _area: int
var _total_moves: int
var _count_of_death: int
var _count_of_teleport: int # on level
#endregion
#region gameplay data
var _camera_in_move = false
var _drag_on_panel = false
#endregion
#region player data
@onready var _player: Player
@onready var _inventory: Inventory
#endregion
#region enteties conteiners
@onready var _perant_for_group_nodes: Node = $PerantForGroupNodes
@onready var _walls: Node = $PerantForGroupNodes/Walls
@onready var _chests: Node = $PerantForGroupNodes/Chests
@onready var _bombs: Node = $PerantForGroupNodes/Bombs
@onready var _rivers: Node = $PerantForGroupNodes/Rivers
@onready var _portals: Node = $PerantForGroupNodes/Portals
@onready var _players: Node = $PerantForGroupNodes/Player
@onready var _entety_massege_parent: Node = $PerantForGroupNodes/EntetyMassegeParent
#endregion
#region ui conteiners
@onready var _inventory_father: Node = $CanvasLayer/Panel/Inventory
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

func comunicate_with_panel(event) -> void:
	event.position -= _ui.position
	if _inventory.set_selected_slot(event.position - _inventory.position):
		return
func _ready():
	var f = FileAccess.open(Global.saves_path + Global.game_name + "/main.txt",FileAccess.READ)
	var stage = f.get_line()
	var part = f.get_line()
	_level_name = f.get_line()
	_level_file_path = Global.saves_path + Global.game_name + '/Levels/' + _level_name + "/"
	_tmp_level_path = Global.saves_path + Global.game_name + "/CurrentLevel/"
	f.close()
	
	_extra_camera.zoom /= 2
	EntityMessageParent.parent = _entety_massege_parent
	ToLobbyTeleporter.add_teleport_func(switch_to_lobby)
	ToLevelTeleporter.add_teleport_func(switch_to_level)
	load_level()
func load_level():
	var ui_v = _ui.visible
	_ui.hide()
	EnvironmentMove.clear()
	current_num_of_ls = 0
	if not FileAccess.file_exists(_tmp_level_path + "main.txt"):
		Global.copy_dirs(
			_level_file_path, _tmp_level_path
		)
		Global.copy_files(
			Global.saves_path + Global.game_name + "/inventory.txt", 
			_tmp_level_path + "Player/inventory.txt"
		)
	change_game_main_file()
#region clearing level	
	for node in _perant_for_group_nodes.get_children():
		for child in node.get_children():
			node.remove_child(child)
			child.queue_free()
	for inv in _inventory_father.get_children():
		_inventory_father.remove_child(inv)
		inv.queue_free()
	_map.clear()
#endregion
#region initializating start data
	var lF = FileAccess.open(_tmp_level_path + "main.txt", FileAccess.READ)
	var line: PackedStringArray = lF.get_line().split(' ', false)
	_area = int(line[0])
	_total_moves = int(line[1])
	_count_of_death = int(line[2])
	_count_of_teleport = int(line[3]) + 1
#endregion
#region initializating player and inventory
	_player = Player.init_from_file(_tmp_level_path + "Player/main.txt", _players)
	_player.moves_changed.connect(next_move)
	_player.health.death.connect(player_death)
	_inventory = Inventory.init(_inventory_father, _player.inventory, Vector2(20, 176), 4)
	current_num_of_ls += 1
	_moves_label.text =  tr("labelLevelMoves") + ": " + str(_player.moves)
#endregion
#region initializating tile map
	var tmf = FileAccess.open(_tmp_level_path + "Config/tilemap.txt", FileAccess.READ)
	line = tmf.get_line().split(' ', false)
	var colum: int = 0
	while line.size() != 0:
		for i in range(line.size()):
			_map.set_cell(0, Vector2i(i, colum), int(line[i]), Vector2(0,0), 0)
			if _count_of_teleport == 1:
				_area += 1
		colum += 1
		line = tmf.get_line().split(' ', false)
	tmf.close()
#endregion
#region initializating unbreacable walls 
	tmf = FileAccess.open(_tmp_level_path + "Config/tilemap.txt", FileAccess.READ)
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
	current_num_of_ls += 1
#endregion
	Portal.init_portals(_portals, _tmp_level_path + "Config/Plains/Portals/")
	Wall.init_walls(_walls, _tmp_level_path + "Config/Structure/Walls/")
	Chest.init_chests(_chests, _tmp_level_path + "Config/Structure/Chests/")
	Rivers.init_rivers(_rivers, _tmp_level_path + "Config/Plains/Rivers/")
	Bombs.init_bombs(_bombs, _tmp_level_path + "Config/Structure/Bombs/")
	
	_camera.position = _player.position
	_ui.visible = ui_v

func next_move():
	EnvironmentMove.next_env_move()
	_moves_label.text = tr("labelLevelMoves") + ": " + str(_player.moves)
	save_main_file()

func change_game_main_file() -> void:
	var gmain = FileAccess.open(Global.saves_path + Global.game_name + "/main.txt", FileAccess.READ)
	var line = gmain.get_as_text().split('\n', false)
	gmain.close()
	gmain = FileAccess.open(Global.saves_path + Global.game_name + "/main.txt", FileAccess.WRITE)
	line[2] = _level_name
	for l in line:
		gmain.store_line(l)
	gmain.close()

#region gameplay
func player_death():
	if _player.independent_movement.on_move: 
		_player.independent_movement.stop_move()
		_count_of_death += 1
	for p in _portals.get_children():
		if p is ToLobbyPortal:
			_player.position = p.position
func switch_to_level(level_path) -> void:
	var ui_v = _ui.visible
	_ui.hide()
	
	await update_texture()
	save_level()
	_level_file_path = level_path
	_level_name = _level_file_path.left(_level_file_path.length() - 1 - _level_file_path.rfind('/'))
	load_level()
	
	_ui.visible = ui_v
func switch_to_lobby(lobby_path: String) -> void:
	#level_name = "Lobby"
	var t_path = _level_file_path + "texture.png"
	var ui_v = _ui.visible
	_ui.hide()
	
	await update_texture()
	
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
	
	save_level()
	_level_file_path = lobby_path
	_level_name = "Lobby"
	load_level()
	
	var eoln = EndOfLevelNotification.init(
		$CanvasLayer, tr(_level_name), _player.moves, get_inv, spent_inv, t_path
	)
	await eoln.time_to_continue
	_ui.visible = ui_v

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
	
	if not _inventory.selected_slot == null:
		match(_inventory.selected_slot.data.tag):
#region using Grenate (*)
			"Grenate":
				if event is InputEventScreenDrag:
					var ep = transform_global_position_to_local(event.position)
					var dir: Vector2 = -(_player.position - ep)
					_player.rotation = dir.angle() + PI/2
				elif event is InputEventScreenTouch:
					if not event.pressed:
						#setGrenate(20, 0.3)
						_player.throw_granate()
						_inventory.selected_slot = null
						#$CanvasLayer/Panel/Inventory.selectedSlot.itemCount -= 1
#endregion
#region using Bomb (*)
			"Bomb":
				if event is InputEventScreenTouch:
					var ep = transform_global_position_to_local(event.position)
					var delta_coords = abs(
						Level.to_tilemap_coords(_player.position) - Level.to_tilemap_coords(ep)
					)
					if delta_coords.x == 0 && delta_coords.y == 0:
						_player.plant_bomb(ep, _bombs)
						_inventory.selected_slot = null
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
	
	var ep = transform_global_position_to_local(event.position)
	var event_tile_position = Level.to_tilemap_coords(ep)
	var delta_coords = abs(Level.to_tilemap_coords(_player.position) - event_tile_position)
	if (not delta_coords.x == 0 or delta_coords.y > 1) and (delta_coords.x > 1 or not delta_coords.y == 0):
		return
#region tap behind players cell (player's movement)
	if (not delta_coords.x == 0 or not delta_coords.y == 0):
		event_tile_position.x = event_tile_position.x * Global.size + Global.size / 2
		event_tile_position.y = event_tile_position.y * Global.size + Global.size / 2
		_player.move_to(event_tile_position)
		return
#endregion
#endregion

func update_texture() -> void:
	var ui_v := _ui.visible
	_ui.hide()
	_extra_camera.enabled = true
	_camera.enabled = false
	_extra_camera.position = _player.position
	await RenderingServer.frame_post_draw
	var viewport = _extra_camera.get_viewport()
	var img = viewport.get_texture().get_image()
	img.save_png(_tmp_level_path + "texture.png")
	_camera.enabled = true
	_extra_camera.enabled = false
	_ui.visible = ui_v
func save_level() -> void:
	save_main_file()
	_player.moves = 0
	Global.delete_files(_level_file_path)
	Global.copy_dirs(_tmp_level_path, _level_file_path)
	Global.copy_files(_player.inventory.path, Global.saves_path + Global.game_name + "/inventory.txt")
	Global.delete_files(_tmp_level_path)
func save_main_file() -> void:
	var mf = FileAccess.open(_tmp_level_path + "main.txt", FileAccess.WRITE)
	mf.store_line(
		str(_area) + " " + str(_total_moves + _player.moves) + " " + str(_count_of_death) + " " + str(_count_of_teleport)
	)
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

