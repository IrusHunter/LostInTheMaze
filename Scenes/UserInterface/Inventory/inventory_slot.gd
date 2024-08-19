class_name InventorySlot
extends Control

#region fields
const path: String = "res://Scenes/UserInterface/Inventory/inventory_slot.tscn"
var _item: Item
@onready var _counter: Label = $Frame/Counter
@onready var _frame: TextureRect = $Frame
#endregion

func _ready():
	pass
static func init(parent: Node, item_data: ItemData) -> InventorySlot:
	var inv = preload(path).instantiate()
	parent.add_child(inv)
	inv._item = Item.init(inv._frame, item_data)
	inv.data.count_changed.connect(inv.reset)
	inv.reset()
	return inv

#region properties
var data: ItemData:
	get:
		return _item.data
#endregion

#region metods
func reset():
	if data.count != 0:
		_counter.text = str(data.count)
	#else: 
		#counter.text = ""
#endregion


