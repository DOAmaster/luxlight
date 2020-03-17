extends Node2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(tempTurn == 2):
		move_local_x(delta * moveDir)
	else:
		move_local_x(-(delta * moveDir))
	

var moveDir = 400
var tempTurn = 1

func _ready():

	"""
	if(myGlobals.playersTurn == 1):
		moveDir = 400
	else:
		moveDir = -400
	"""


func _on_Area2D_area_entered(area):
	if(area.get_collision_layer_bit(2)):
		queue_free()

func _on_Timer_timeout():
	print("timing out bullet")
	queue_free()
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if(body.is_in_group("player")):
		#body.apply_impulse(Vector2(0,0), Vector2(20,0))
		#myGlobals.gameOver = 1
		#get_node("../../GameOverText").visible = true
		get_node("..").energyUp()
		#print("Game Over")
		queue_free()
	elif(body.is_in_group("blocker")):
		print("powerup clipping blocker: removing")
		body.queue_free()
	pass # Replace with function body.
