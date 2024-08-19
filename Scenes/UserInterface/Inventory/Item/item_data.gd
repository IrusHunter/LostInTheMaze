class_name ItemData

#region
var _tag: String
var _count: int
var _max_number: int
static var max_number_of_items = {
	"Free": 0, "Grenate": 10, "Bomb": 10, "GoldCoin": 1000, "BronzeCoin": 1000, "SilverCoin": 1000
}
signal tag_changed
signal count_changed
#endregion

func _init(tag: String = "Free", count: int = 0):
	_tag = tag
	_max_number = max_number_of_items[tag]
	_count = count

#region properties
var tag: String:
	get:
		return _tag
	set(value):
		_tag = value
		_max_number = max_number_of_items[tag]
		tag_changed.emit()
var count: int:
	get:
		return _count
	set(value):
		if value > max_number:
			value = max_number
		if value == 0:
			clear()
		else:
			_count = value
			count_changed.emit()
var max_number: int:
	get:
		return _max_number
#endregion

#region metods
func add_from_item(item: ItemData, c: int = item.count) -> void:
	if item.count < c:
		c = item.count
	
	if equals(item):
		var max_extra_count = max_number - count
		if c < max_extra_count:
			count += c
			item.count -= c
		else:
			count = max_number
			item.count -= max_extra_count
func equals(item: ItemData) -> bool:
	if tag == item.tag: 
		return true
	else: 
		return false
func clear() -> void:
	_tag = "Free"
	_count = 0
	tag_changed.emit()
	count_changed.emit()
func fill(item: ItemData) -> void:
	tag = item.tag
	count = item.count
#endregion






