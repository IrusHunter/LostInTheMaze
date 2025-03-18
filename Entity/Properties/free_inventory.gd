class_name FreeInventory
extends InventoryData

#region fields
signal time_to_rob(inv: InventoryData)
#endregion

#region metods
func active_signal() -> void:
	time_to_rob.emit(self)
#endregion
