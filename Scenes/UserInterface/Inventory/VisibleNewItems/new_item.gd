class_name NewItem
extends Node2D

#region fields
const path: String = "res://Scenes/UserInterface/Inventory/VisibleNewItems/new_item.tscn"
@onready var _counter: Label = $Label
var _item: Item
#endregion

func _ready():
	_item.position = Vector2(-16, -16)
	_counter.text = str(_item.data.count)
	await get_tree().create_timer(2).timeout
	get_parent().remove_child(self)
	queue_free()
func _init():
	pass 
static func init(parent: Node, position: Vector2, item_data: ItemData, scale: float = 1) -> NewItem:
	var ni: NewItem = preload(path).instantiate()
	ni._item = Item.init(ni, item_data)
	parent.add_child(ni)
	ni.position = position
	ni._counter.text = str(item_data.count)
	ni.scale *= scale
	return ni

func _process(delta):
	modulate.a -= delta
	position.y -= Global.size*delta/4

