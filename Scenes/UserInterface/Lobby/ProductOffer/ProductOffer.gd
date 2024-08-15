extends Control

@onready var price = $PriceItem
@onready var product = $ProductItem

var count = 0
var inventory

#c - count of operations, x1 - properties of the product, x2 - properties of the price, inv - inventory
func setOffer(c: int, tag1: String, num1: int, rar1: int, maxNum1: int, tag2: String, num2: int, rar2: int, inv):
	count = c
	$CountOfOperations.text = str(c)
	product.setSlot(tag1, num1, rar1, maxNum1)
	price.setSlot(tag2, num2, rar2, 0)
	inventory = inv

func _on_confirm_offer_button_pressed():
	var countOfPriceItems = 0
	var countOfFreeProductItems = 0
	
	if count == 0:
		print("There are no product")
		return
	
	for slot in inventory.box.get_children():
		if slot.itemTag == price.itemTag && slot.itemRarity == price.itemRarity:
			countOfPriceItems += slot.itemCount
		elif slot.itemTag == product.itemTag && slot.itemRarity == product.itemRarity:
			countOfFreeProductItems += slot.itemMaxNumber - slot.itemCount
		elif slot.itemTag == "free":
			countOfFreeProductItems += product.itemMaxNumber
	
	if countOfPriceItems < price.itemCount:
		print("Not enought items for purchase")
	elif countOfFreeProductItems < product.itemCount:
		print("Not enought space for product")
	else:
		count -= 1
		$CountOfOperations.text = str(count)
		inventory.addToInventory(price.itemTag, -price.itemCount, price.itemRarity, 0)
		inventory.addToInventory(product.itemTag, product.itemCount, product.itemRarity, product.itemMaxNumber)


