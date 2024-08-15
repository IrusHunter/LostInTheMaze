extends Button

var levelName

#position (Vector2), levelName (String)
func setLevelIcon(pos, nL):
	levelName = nL
	position = pos
	$NameLabel.text = levelName
	
func _on_pressed():
	get_tree().change_scene_to_file(Level.path)
	Global.currentLevel = levelName
