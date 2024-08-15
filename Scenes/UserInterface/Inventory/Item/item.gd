class_name Item
extends AnimatedSprite2D

#region fields
const path: String = "res://Scenes/UserInterface/Inventory/Item/item.tscn"
var _data: ItemData
#endregion

func _ready():
	_data.tag_changed.connect(reset)
	reset()
func _init():
	_data = ItemData.new()
static func init(parent: Node, item_data: ItemData) -> Item:
	var itm = preload(Item.path).instantiate()
	itm._data = item_data
	parent.add_child(itm)
	return itm


#region properties
var data: ItemData:
	get:
		return _data
#endregion

#region metods
func reset():
	play(_data.tag)
#endregion

