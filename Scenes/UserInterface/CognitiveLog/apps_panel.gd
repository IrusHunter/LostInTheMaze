class_name CognitiveLogAppPanel
extends Control
## panel that display CognitiveLogApps

const OPEN_X_POSITION = 0 ## destination position for opening
const CLOSE_X_POSITION = -450 ## destination position for closing
var destination: int = 0 ## current destination position
var speed: float = 500 ## movement speed
var time_to_move = false
var _background_panel: BackgroundPanel
@onready var _bp_container: Control = $BPContainer


func _ready() -> void:
	# initing BackgroundPanel
	_background_panel = BackgroundPanel.init(_bp_container, self, _close)


func _process(delta: float) -> void:
	# check if control must move
	if  time_to_move:
		# check if control on destination position
		# it doesn't twitch with speed*delta*2
		if abs(float(destination) - position.x) > speed*delta*2:
			position.x += sign(float(destination) - position.x) * speed * delta
		else:
			time_to_move = false


## call when is time to close
func _close() -> void:
	time_to_move = true
	_background_panel.hide()
	destination = CLOSE_X_POSITION
## call when is time to open
func _open() -> void:
	time_to_move = true
	_background_panel.show()
	destination = OPEN_X_POSITION


func _on_switcher_pressed() -> void:
	if destination == OPEN_X_POSITION:
		_close()
	else:
		_open()
