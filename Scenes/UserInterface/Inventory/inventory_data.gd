class_name InventoryData

#region fields
var _items: Array[ItemData] = []
var _path: String = Global.init_unit_path
var _selected_item: ItemData = null
#endregion

func _init(file: String):
	_path = file
	if file == "":
		return
	
	clear()
	var iF = FileAccess.open(file,FileAccess.READ)
	var line: PackedStringArray = iF.get_line().split(' ',false)
	while line.size() > 0:
		if line.size() == 2: 
			add_new_item(ItemData.new(line[0], int(line[1])))
		else: 
			breakpoint
			add_new_item()
		line = iF.get_line().split(' ', false)
	iF.close()

#region properties
var items: Array[ItemData]:
	get:
		return _items
var path: String:
	get:
		return _path
var selected_item: ItemData:
	get:
		return _selected_item
	set(value):
		_selected_item = value
#endregion

#region metods
func add_item(item: ItemData, c: int = item.count) -> void:
	var delta = item.count - c
	if delta < 0:
		delta = 0
		c = item.count
	
	# check if any slot already have this item
	for i in items:
		if i.equals(item):
			i.add_from_item(item, c)
			c = item.count - delta
			if c <= 0:
				return
	# run throught the free slots
	for i in items:
		if i.tag == "Free":
			var tmp_i = ItemData.new()
			tmp_i.fill(item)
			tmp_i.count -= delta
			item.count = delta
			i.fill(tmp_i)
func add_new_item(item: ItemData = ItemData.new()) -> void:
	_items.append(item)
func clear() -> void:
	_items.clear()
func save() -> void:
	var iF = FileAccess.open(path, FileAccess.WRITE)
	for item: ItemData in items:
		iF.store_line(item.tag + " " + str(item.count))
	iF.close()
#func upload(file: String):
	#clear()
	#var iF = FileAccess.open(file,FileAccess.READ)
	#var line: PackedStringArray = iF.get_line().split(' ',false)
	#while line.size() > 0:
		#if line.size() == 4: add_new_item(ItemData.new(line[0], int(line[3]), int(line[1]), int(line[2])))
		#else: add_new_item()
		#line = iF.get_line().split(' ', false)
	#iF.close()
func is_clear() -> bool:
	for i: ItemData in items:
		if i.count != 0: return false
	return true
#endregion



