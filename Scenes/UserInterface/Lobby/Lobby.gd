class_name Lobby
extends Node2D

const path: String = "res://Scenes/UserInterface/Lobby/Lobby.tscn"
@onready var storage: Panel = $CanvasLayer/StoragePanel
#
#var levelPreload = preload("res://Scenes/UserInterface/Lobby/LevelIcon.tscn")
#var deltaForLevels = Vector2()
#var shopOfferPreload = preload("res://Scenes/UserInterface/Lobby/ProductOffer/ProductOffer.tscn")
#var deltaForOffer = Vector2()
#
#var inventory: Inventory
#var storage_data: Inventory
##@onready var storage = $CanvasLayer/StoragePanel/Storage
#
#func _ready():
	##generating LevelIcons
	#for i in range(Global.countOfLevels):
		#var level = levelPreload.instantiate()
		#$Levels.add_child(level)
		#deltaForLevels = level.size + Vector2(10,10)
		#level.setLevelIcon(Vector2(40 + deltaForLevels.x*int(i/4), 120 + deltaForLevels.y*(i % 4)), "Level"+str(i+1))
	#
	#storage.hide()
	#$CanvasLayer/ShopPanel.hide()
	#clearShopOffers()
	#
	#
	##$CanvasLayer/StoragePanel/Inventory.clear()
	##$CanvasLayer/StoragePanel/Storage.clear()
	#$CanvasLayer/ShopPanel/Inventory.clear()
#
#func _on_menu_button_pressed():
	#get_tree().change_scene_to_file("res://Scenes/UserInterface/Menus/MainMenu.tscn")
#
#func interact_with_storage(event):
	#event.position -= storage.position
	#if (event.position.x < 0) or (event.position.y < 0):
		#_on_exit_from_storage_button_pressed()
	#elif (event.position.x > storage.size.x) or (event.position.y > storage.size.y):
		#_on_exit_from_storage_button_pressed()
	#elif inventory.set_selected_slot(event.position - inventory.position) != 0:
		#storage_data.add_item(inventory.selected_slot.data)
	#elif storage_data.set_selected_slot(event.position - storage_data.position) != 0:
		#inventory.add_item(storage_data.selected_slot.data)
#func _input(event):
	#if !(event is InputEventScreenTouch):
		#return
	#if event.pressed:
		#return
	#
	#if storage.visible:
		#interact_with_storage(event)
		#return
##region interacting with shop
	#if $CanvasLayer/ShopPanel.visible:
		#event.position -= $CanvasLayer/ShopPanel.position
		#if event.position.x < 0 || event.position.y < 0:
			#_on_exit_from_shop_pressed()
		#elif event.position.x > $CanvasLayer/ShopPanel.size.x || event.position.y > $CanvasLayer/ShopPanel.size.y:
			#_on_exit_from_shop_pressed()
##endregion
	#
#
##Stprage
#func _on_storage_button_pressed():
	##inventory = $CanvasLayer/StoragePanel/Inventory
	#inventory = Inventory.init(storage, Global.userPath + "Inventory.txt", Vector2(33, 74))
	#inventory.disable_selected_frame()
	#storage_data = Inventory.init(storage, Global.userPath + "Storage.txt", Vector2(265, 74), 10)
	#storage_data.disable_selected_frame()
	##inventory.upload(Global.userPath + "Inventory.txt")
	##storage_data.upload(Global.userPath + "Storage.txt")
	##storage_data.box.columns = 10
	##storage.sslot.hide()
	##inventory.sslot.hide()
	#storage.show()
#func _on_exit_from_storage_button_pressed():
	#storage.hide()
	#inventory.save()
	#inventory.clear_slots()
	#storage_data.save()
	#storage_data.clear_slots()
#
##Shop
#func clearShopOffers():
	#for i in $CanvasLayer/ShopPanel/ShopOffers.get_children():
		#$CanvasLayer/ShopPanel/ShopOffers.remove_child(i)
		#i.queue_free()
#func _on_shop_button_pressed():
	#inventory = $CanvasLayer/ShopPanel/Inventory 
	#
	##generating ShopOffers
	#var oF = FileAccess.open(Global.userPath + "ShopOffers.txt", FileAccess.READ)
	#var line = oF.get_line()
	#var tmpCount = 0
	#while line!="":
		#Global.p = 0
		#var offer = shopOfferPreload.instantiate()
		#$CanvasLayer/ShopPanel/ShopOffers.add_child(offer)
		#deltaForOffer = offer.size*offer.scale + Vector2(2,2)
		#offer.position = Vector2(deltaForOffer.x*int(tmpCount/5), deltaForOffer.y*(tmpCount % 5))
		#offer.setOffer(int(Global.slovo(line)), Global.slovo(line), int(Global.slovo(line)), int(Global.slovo(line)), int(Global.slovo(line)), Global.slovo(line), int(Global.slovo(line)), int(Global.slovo(line)), inventory)
		#tmpCount += 1
		#line = oF.get_line() 
	#
	#inventory.setInventory("Inventory.txt")
	#inventory.sslot.hide()
	#$CanvasLayer/ShopPanel.show()
#func _on_exit_from_shop_pressed():
	#inventory.saveInventory("Inventory.txt")
	#inventory.clear()
	#
	##save ShopOffers
	#var oF = FileAccess.open(Global.userPath + "ShopOffers.txt", FileAccess.WRITE)
	#for offer in $CanvasLayer/ShopPanel/ShopOffers.get_children():
		#var line = str(offer.count) + " "
		#line += offer.product.itemTag + " " + str(offer.product.itemCount) + " " + str(offer.product.itemRarity) + " " + str(offer.product.itemMaxNumber) + " "
		#line += offer.price.itemTag + " " + str(offer.price.itemCount) + " " + str(offer.price.itemRarity)
		#oF.store_line(line)
	#clearShopOffers()
	#$CanvasLayer/ShopPanel.hide()
