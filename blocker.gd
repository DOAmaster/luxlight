extends Node2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(tempTurn == 2):
		move_local_x(delta * moveDir)
	else:
		move_local_x(-(delta * moveDir))
	

var moveDir = 400
var tempTurn = 1
var active

func _ready():
	"""
	if(myGlobals.playersTurn == 1):
		moveDir = 400
	else:
		moveDir = -400
	"""

func _on_screen_exited():
	queue_free()

func _on_Area2D_area_entered(area):
	if(area.is_in_group("pickup")):
		print("blocking powerup removing")
		self.queue_free()

func _on_Timer_timeout():
	print("timing out blocker")
	queue_free()
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if(body.is_in_group("player")):
		#body.apply_impulse(Vector2(0,0), Vector2(20,0))
		myGlobals.gameOver = 1
		#get_node("../../GameOverText").visible = true
		print("Game Over")
		get_node("../deathSound").play()
		queue_free()
	elif(body.is_in_group("P1Box") || tempTurn == 2):
		body.apply_impulse(Vector2(0,0), Vector2(-20,0))
		queue_free()
	pass # Replace with function body.

func _on_VisibilityNotifier2D_screen_exited():
	active = false
	#print("off screen")


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	#print("off screen")
	var myX = position[0]
	#print(myX)
	if(myX <= 100):
		#print("score range")
		var tempScore = myGlobals.score + 10
		myGlobals.score = tempScore
		self.queue_free()
	pass # Replace with function body.
