class_name NewItemGenerator
extends Node2D

#region fields
var _inventory: FreeInventory
#endregion

static func init(start_position: Vector2, inventory: FreeInventory) -> NewItemGenerator:
	var nig = NewItemGenerator.new()
	nig._inventory = inventory
	EntityMessageParent.add_child(nig)
	nig.position = start_position
	return nig

#region metods
func start_creating_new_items() -> void:
	var inv = InventoryData.new(_inventory.path)
	_inventory.active_signal()
	for i in range(inv.items.size()):
		var itm = ItemData.new()
		itm.fill(inv.items[i])
		itm.count -= _inventory.items[i].count
		if itm.count != 0:
			await get_tree().create_timer(0.5).timeout
			NewItem.init(self, Vector2(0,0), itm, 0.3)
	_inventory.save()
#endregion
