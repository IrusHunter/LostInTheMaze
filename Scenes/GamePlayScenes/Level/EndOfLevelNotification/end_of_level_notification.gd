class_name EndOfLevelNotification
extends Control

#region fields
const path: String = "res://Scenes/GamePlayScenes/Level/EndOfLevelNotification/end_of_level_notification.tscn"
@onready var _info_panel: Panel = $Panel/Info
@onready var _name_label: Label = $Panel/Info/Name
@onready var _moves_label: Label = $Panel/Info/Moves
var _items_get_position := Vector2(26, 171)
var _items_spent_position := Vector2(26, 243)
@onready var _image: TextureRect = $Panel/TextureRect
@onready var _continue_button: Button = $Panel/Info/Continue
signal time_to_continue
#endregion

static func init(
	parent: Node, name: String, moves: int, items_get: InventoryData, items_spent: InventoryData, image: String,
	) -> EndOfLevelNotification:
		var eoln: EndOfLevelNotification = preload(path).instantiate()
		parent.add_child(eoln)
		eoln._name_label.text = name
		eoln._moves_label.text = TranslationServer.tr("labelLevelMoves") + ": " + str(moves)
		Inventory.init(eoln._info_panel, items_get, eoln._items_get_position, 10)
		Inventory.init(eoln._info_panel, items_spent, eoln._items_spent_position, 10)
		eoln._image.texture = ImageTexture.create_from_image(Image.load_from_file(image))
		return eoln

func _process(delta):
	if Level.load_stages == Level.current_num_of_ls:
		_continue_button.disabled = false

func _on_continue_pressed():
	time_to_continue.emit()
	get_parent().remove_child(self)
	queue_free()
