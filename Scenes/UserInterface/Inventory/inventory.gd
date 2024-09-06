class_name Inventory
extends Control

#region fields
const path: String = "res://Scenes/UserInterface/Inventory/inventory.tscn"
@onready var _selected_frame: AnimatedSprite2D = $SelectedSlot
@onready var _box: GridContainer = $Box
var _selected_slot: InventorySlot = null 
var _data: InventoryData = null
#endregion

func _ready():
	_selected_frame.visible = false
	load_from_data()
func _init():
	_data = InventoryData.new("")
static func init(parent: Node, inv_data: InventoryData, position: Vector2, colums: int = 4) -> Inventory:
	var inv = preload(path).instantiate()
	inv._data = inv_data
	parent.add_child(inv)
	inv.position = position
	inv._box.columns = colums
	return inv

#region properties
var data: InventoryData:
	get:
		return _data
var selected_slot: InventorySlot:
	get:
		return _selected_slot
	set(value):
		_selected_slot = value
		if not value == null:
			_data.selected_item = value.data
			_selected_frame.position = _selected_slot.position + Vector2(20, 20)
			_selected_frame.show()
		else:
			_selected_frame.hide()
			_data.selected_item = null
#endregion

#region metods
#NOTE: return true if s_slot has been set
func set_selected_slot(pos: Vector2) -> bool:
	for slot: InventorySlot in _box.get_children():
		var delta_position = abs(pos - slot.position - Vector2(21,21))
		if (delta_position.x < 21) && (delta_position.y < 21):
			if _selected_slot == slot:
				selected_slot = null
			else:
				selected_slot = slot
			return true
	return false
#func clear_slots():
	#selected_slot = null
	#_selected_frame.visible = false
	#_data = InventoryData.new(inventory_path)
	#for s in _box.get_children():
		#_box.remove_child(s)
		#s.queue_free()
func load_from_data():
	for s in _box.get_children():
		_box.remove_child(s)
		s.queue_free()
	for i in _data.items:
		InventorySlot.init(_box, i)
func disable_selected_frame():
	_selected_frame.modulate.a = 0
func unable_selected_frame():
	_selected_frame.modulate.a = 1
#endregion


#var itemPreload = preload("res://Scenes/UserInterface/Inventory/InventorySlot.tscn")
#var count = 0
#var selectedSlot #slot - node
#@onready var sslot = $SelectedSlot #frame
#
##File allocation at userData folder
#func setInventory(fileName):
	#clear()
	##generat inventory
	#var iF = FileAccess.open(Global.userPath+fileName,FileAccess.READ)
	#count = 0
	#var line = iF.get_line()
	#while line!="":
		#var item = itemPreload.instantiate()
		#item.name = "ItemSlot" + str(count)
		#Global.p = 0
		#item.setSlot(Global.slovo(line), int(Global.slovo(line)), int(Global.slovo(line)), 
		#int(Global.slovo(line)))
		#box.add_child(item)
		#count += 1
		#line = iF.get_line()
	#selectedSlot = $Box/ItemSlot0
	#sslot.position = Vector2(20, 20)
	#iF.close()
#func saveInventory(fileName):
	#var iF = FileAccess.open(Global.userPath+fileName,FileAccess.WRITE)
	#for item in box.get_children():
		#iF.store_line(item.itemTag + " " + str(item.itemCount) + " " + str(item.itemRarity) + " " + \
		#str(item.itemMaxNumber))
	#iF.close()
#
##func clear():
	##for i in box.get_children():
		##if i != sslot:
			##box.remove_child(i)
			##i.queue_free()
#func addToInventory(t: String, num: int, rarity: int, maxNumber: int):
	##check if any slot already have this item
	#for slot in box.get_children():
		#if slot.itemTag == t:
			#var maxCap = slot.itemMaxNumber - slot.itemCount
			#if maxCap <= num:
				#slot.itemCount = slot.itemMaxNumber
				#num -= maxCap
			#else:
				#slot.itemCount += num
				#num = 0
	##run throught the free slots
	#for slot in box.get_children():
		#if slot.itemTag == "free" && num!=0:
			#if maxNumber <= num:
				#slot.setSlot(t, maxNumber, rarity, maxNumber)
				#num -= maxNumber
				#continue
			#else:
				#slot.setSlot(t, num, rarity, maxNumber)
				#num = 0
	#return num
##local position of touch
#func setSslot(pos):
	#for slot in box.get_children():
		#var deltaPos = abs(pos - slot.position - Vector2(21,21))
		#if (deltaPos.x < 21) && (deltaPos.y < 21):
			#if selectedSlot == slot:
				#return 10
			#selectedSlot = slot
			#sslot.position = selectedSlot.position + Vector2(20, 20)
			#return 1
	#return 0
	
