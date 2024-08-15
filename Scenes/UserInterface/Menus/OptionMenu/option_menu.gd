class_name OptionMenu
extends Control

const path: String = "res://Scenes/UserInterface/Menus/OptionMenu/option_menu.tscn"
@onready var music = $Panel/music
@onready var sounds = $Panel/sounds
@onready var e = $exitScreen
var options_data_path = Global.user_path + "Settings.txt"

func _ready():
	music.set_value_no_signal(Global.music_level)
	sounds.set_value_no_signal(Global.sounds_level)

#save to FILE and to GLOBAL
func _on_save_button_pressed():
	Global.musicLevel = music.value
	Global.soundsLevel = sounds.value
	var sF = FileAccess.open(options_data_path,FileAccess.WRITE)
	sF.store_line(str(music.value))
	sF.store_line(str(sounds.value))
	sF.close()
func _on_reset_button_pressed():
	var fSett = FileAccess.open(Global.startDataPath+"Settings.txt", FileAccess.READ)
	Global.music_level = float(fSett.get_line())
	Global.sounds_level = float(fSett.get_line())
	fSett.close()
	_ready()
#check with GLOBAL if any option was changed
func _on_exit_button_pressed():
	if (music.value==Global.music_level) && (sounds.value==Global.sounds_level): 
		hide()
	else:
		e.show()
func _on_cancel_button_pressed():
	_ready()

func _on_yes_button_pressed():
	_on_save_button_pressed()
	e.hide()
	hide()
func _on_no_button_pressed():
	e.hide()
	hide()

func _input(event):
	if event is InputEventScreenTouch && visible:
		if event.pressed:
			return
		if visible:
			event.position -= position
			if event.position.x < -$Panel.size.x/2 || event.position.y < -$Panel.size.y/2:
				_on_exit_button_pressed()
			elif event.position.x > $Panel.size.x/2 || event.position.y > $Panel.size.y/2:
				_on_exit_button_pressed()


func unpressOtherLangButtons(select):
	for b in $Panel/LanguageButtons.get_children():
		if b!=select:
			b.modulate.b = 1
		else:
			b.modulate.b = 0
func _on_english_pressed():
	TranslationServer.set_locale("en")
	unpressOtherLangButtons($Panel/LanguageButtons/english)
func _on_ucrainian_pressed():
	TranslationServer.set_locale("ua")
	unpressOtherLangButtons($Panel/LanguageButtons/ucrainian)
