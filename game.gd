extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerLight = 1
#var score = 0
var UIplayer 
var clearerPlayer
var musicPlayer
#var gameStart = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	UIplayer = $UIAnimationPlayer
	clearerPlayer = $ClearerAnimation
	musicPlayer = $MusicPlayer
	#menuMusicPlayer = $MenuMusicPlayer
	
	get_node("MenuMusicPlayer").play()
	get_node("MusicPlayer").stop()
	#musicPlayer.play()
	get_node("ScoreText").text = str(myGlobals.score)
	get_node("ScoreText").visible = false
	get_node("GameLogo/CPUParticles2D").emitting = true
	#UIplayer.play("lowLife")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(myGlobals.gameStart == 0):
		UIplayer.play("fadeinfo")
		get_node("SpawnBlockerTimer").start()
		get_node("SpawnPickupTimer").start()
		get_node("SpawnPickupWaveTimer").start()
	else:
		#musicPlayer.play()
		get_node("MenuMusicPlayer").stop()
		clearerPlayer.play("slow")
		get_node("GameLogo").visible = false
		get_node("ScoreText").visible = true
	if(myGlobals.gameOver == 1):
		get_node("GameOverText").visible = true
		get_node("SpawnBlockerTimer").stop()
		get_node("SpawnPickupTimer").stop()
		get_node("SpawnPickupWaveTimer").stop()
		get_node("MusicPlayer").stop()
		get_node("SpawnBlockerTimer").wait_time = 1
	else:
		#game in play
		#difficulty ramp
		get_node("ScoreText").text = str(myGlobals.score)
		if(myGlobals.score <= 50):
			get_node("SpawnBlockerTimer").wait_time = 1
		elif(myGlobals.score > 50 && myGlobals.score <= 100):
			get_node("SpawnBlockerTimer").wait_time = .9
		elif(myGlobals.score > 100 && myGlobals.score <= 250):
			get_node("SpawnBlockerTimer").wait_time = .8
		elif(myGlobals.score > 250 && myGlobals.score <= 300):
			get_node("SpawnBlockerTimer").wait_time = .7
		elif(myGlobals.score > 300 && myGlobals.score <= 350):
			get_node("SpawnBlockerTimer").wait_time = .6
		elif(myGlobals.score > 350 && myGlobals.score <= 400):
			get_node("SpawnBlockerTimer").wait_time = .5
		elif(myGlobals.score > 400 && myGlobals.score <= 450):
			get_node("SpawnBlockerTimer").wait_time = .4
		elif(myGlobals.score > 450 && myGlobals.score <= 500):
			get_node("SpawnBlockerTimer").wait_time = .3
		elif(myGlobals.score > 500 && myGlobals.score <= 550):
			get_node("SpawnBlockerTimer").wait_time = .2
		elif(myGlobals.score > 1000 && myGlobals.score <= 3000 ):
			get_node("SpawnBlockerTimer").wait_time = .1
			clearerPlayer.play("medium")
		elif(myGlobals.score > 3000 && myGlobals.score <= 5000 ):
			get_node("SpawnBlockerTimer").wait_time = .1
			clearerPlayer.play("fast")
			#print("timer .9")
		#get_tree().paused = true
	pass

func spawnPickupWave():
	#print("Spawning PickupWave")
	var projectile = load("res://pickup.tscn")
	var bullet = projectile.instance()
	#pick random y value between top 16 bottom 584
	bullet.position = Vector2(784,20)
	add_child(bullet)
	var bullet2 = projectile.instance()
	#pick random y value between top 16 bottom 584
	bullet2.position = Vector2(784,300)
	add_child(bullet2)
	var bullet3 = projectile.instance()
	#pick random y value between top 16 bottom 584
	bullet3.position = Vector2(784,580)
	add_child(bullet3)

func _input(event):
	#DEBUG TODO REMOVE ON RELEASE
	if Input.is_key_pressed(KEY_K):
		print("Debugging level skip")
		var tempScore = myGlobals.score + 500
		myGlobals.score = tempScore
		#code
	if event is InputEventKey and event.is_pressed() and myGlobals.gameOver == 1:
		print ("restarting")
		myGlobals.gameOver = 0
		myGlobals.score = 0
		myGlobals.gameStart = 0
		get_tree().change_scene("res://light_shadows.tscn")

func energyUp():
	var tempEnergy = get_node("player/char").energy + 0.5 
	if tempEnergy >= 1.5:
		tempEnergy = 1.5
	get_node("pickupSound").play()
	get_node("player/char").energy = tempEnergy
	print("Energy: ", tempEnergy)

func energyDown():
	var tempEnergy = get_node("player/char").energy - 0.5 
	if tempEnergy <= 0:
		tempEnergy = 0
		myGlobals.gameOver = 1
	get_node("player/char").energy = tempEnergy
	print("Energy: ", tempEnergy)

func _on_DrainTimer_timeout():
	if(myGlobals.gameStart == 1):
		var tempEnergy = get_node("player/char").energy - 0.01 
		if tempEnergy <= 0:
			tempEnergy = 0
			myGlobals.gameOver = 1
		get_node("player/char").energy = tempEnergy
		print("Energy: ", tempEnergy)
	pass # Replace with function body.


func _on_SpawnBlockerTimer_timeout():
	var projectile = load("res://blocker.tscn")
	var bullet = projectile.instance()
	#pick random y value between top 16 bottom 584
	var randY = randi() % 584 + 16
	bullet.position = Vector2(910,randY)
	add_child(bullet)
	#add_child_below_node(get_tree().get_root().get_node("LightShadows"),bullet)
	pass # Replace with function body.


func _on_SpawnPickupTimer_timeout():
	var projectile = load("res://pickup.tscn")
	var bullet = projectile.instance()
	#pick random y value between top 16 bottom 584
	var randY = randi() % 584 + 16
	bullet.position = Vector2(784,randY)
	add_child(bullet)
	pass # Replace with function body.

#hit the pathClearer delete blocker
func _on_Area2D_body_entered(body):
	print("blocker hit")
	if(body.is_in_group("blocker")):
		print("clearing block")
		body.queue_free()
	pass # Replace with function body.




func _on_Area2D_area_entered(area):
	print("blocker hit")
	if(area.is_in_group("blocker")):
		print("clearing block")
		area.get_owner().queue_free()
		#area.queue_free()
	pass # Replace with function body.


func _on_SpawnPickupWaveTimer_timeout():
	spawnPickupWave()
	#get_node("SpawnPickupWaveTimer").stop()
	pass # Replace with function body.

#replay music maybe new sound track
func _on_MusicPlayer_finished():
	get_node("MusicPlayer").play()
	pass # Replace with function body.


func _on_MenuMusicPlayer_finished():
	get_node("MenuMusicPlayer").play()
	pass # Replace with function body.
