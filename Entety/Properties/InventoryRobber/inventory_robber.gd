class_name InventoryRobber
extends Area2D

#region fields
const path: String = "res://Entety/Properties/InventoryRobber/inventory_robber.tscn"
#var _available_free_inv: Array[FreeInventory] = []
var _inventory: InventoryData
#endregion

static func init(parent: Node, inventory: InventoryData, radius: float) -> InventoryRobber:
	var ir = preload(path).instantiate()
	ir._inventory = inventory
	parent.add_child(ir)
	ir.scale *= radius
	return ir

#region metods
func rob_from(inv: FreeInventory) -> void:
	for i in inv.items:
		_inventory.add_item(i)
	inv.save()
	_inventory.save()
#endregion

func _on_body_entered(body: PhysicsBody2D):
	if body.get("free_inventory") != null:
		body.free_inventory.time_to_rob.connect(rob_from)
		#_available_free_inv.append(body.free_inventory)

func _on_body_exited(body):
	if body.get("free_inventory") != null:
		body.free_inventory.time_to_rob.disconnect(rob_from)
		#_available_free_inv.remove_at(_available_free_inv.find(body.free_inventory))
