class_name InNodePanel
extends CanvasLayer

#region fields
const path := "res://Scenes/InNodePanel/in_node_panel.tscn"
var _main_panel: Panel
@onready var _background: Panel = $Panel
#endregion

func _ready():
	#hide()
	pass
static func init(parent: Node, panel: Panel) -> InNodePanel:
	var inp: InNodePanel = preload(path).instantiate()
	parent.add_child(inp)
	panel.get_parent().remove_child(panel)
	inp._background.add_child(panel)
	inp._main_panel = panel
	return inp

#region metods
func death() -> void:
	hide()
#endregion

func _input(event):
	if event is InputEventScreenTouch and visible:
		if event.pressed:
			return
		var delta = event.position - _main_panel.position - _background.position
		if (
			delta.x < 0 or delta.y < 0
			or delta.x > _main_panel.size.x or delta.y > _main_panel.size.y
		):
			death()
