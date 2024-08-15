class_name NeighborsControlModule
extends Node2D

#region properties
const path = "res://Entety/Structure/Walls/NeighborsControlModule/neighbors_control_module.tscn"
var _down_n1: bool = false
var _up_n2: bool = false
var _priority: int
enum priorities{STONE = 0, STEAL = 1, UNBREAKABLE = 100_000}
@onready var _first_sensor: Area2D = $FirstArea
@onready var _second_sensor: Area2D = $SecondArea
#endregion

static func init(parent: Node, priority: int) -> NeighborsControlModule:
	var ncm: NeighborsControlModule = preload(path).instantiate()
	ncm._priority = priority
	parent.add_child(ncm)
	return ncm

#region metods
func get_neighbor_walls() -> int:	
	if (_first_sensor.get_overlapping_bodies().size() == 0):
		await _first_sensor.body_entered
	for body in _first_sensor.get_overlapping_bodies():
		if body.has_meta("priority"):
			if body.priority > _priority:
				_down_n1 = true
	if (_second_sensor.get_overlapping_bodies().size() == 0):
		await _second_sensor.body_entered	
	for body in _second_sensor.get_overlapping_bodies():
		if body.has_meta("priority"):
			if body.priority > _priority:
				_up_n2 = true
	var code: int = 0
	if _down_n1: code += 1
	if _up_n2: code += 2
	return code
func remove() -> void:
	get_parent().remove_child(self)
	queue_free()
#endregion
