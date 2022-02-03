extends StaticBody2D

var talking = false
var player
onready var Log = preload("res://Char/Log/Log.tscn")
onready var animstate = $AnimationTree.get("parameters/playback")

func _ready():
	$PopUp.hide()
	$Timer.connect("timeout", self, "_blink")
	$Timer.start()

func _pop(Player):
	$PopUp.show()
	
	player = Player
	
	if Input.is_action_just_pressed("Interact") and !talking:
		get_tree().root.add_child(Log.instance())
		get_tree().root.get_node("Log")._identification(self)
		talking = true
		get_tree().paused = true

func _conversation_ended():
	talking = false
	get_tree().paused = false

func _unpop():
	$PopUp.hide()

func _blink():
	animstate.travel("Blink")
	$Timer.wait_time = randi() %3 + 2
	$Timer.start()

