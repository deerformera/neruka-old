extends StaticBody2D

var talking = false
var player
onready var Shop = preload("res://Char/Shop/Shop.tscn")
onready var animstate = $AnimationTree.get("parameters/playback")


func _pop(Player):
	$PopUp.show()
	player = Player

func _on_interacted():
	if not talking:
		get_tree().root.add_child(Shop.instance())
		get_tree().root.get_node("Shop")._identification(self)
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

