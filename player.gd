extends KinematicBody2D

# Pickable needs to be selected from the inspector

var can_grab = false
var grabbed_offset = Vector2()

var grabbed = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab and myGlobals.gameOver == 0:
		myGlobals.gameStart = 1
		grabbed = true
		get_node("../MusicPlayer").play()
		position = get_global_mouse_position() + grabbed_offset
	if(grabbed && myGlobals.gameOver == 0):
		position = get_global_mouse_position()
