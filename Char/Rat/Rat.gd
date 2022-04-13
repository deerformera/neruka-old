extends StaticBody2D

onready var animstate = $AnimationTree.get("parameters/playback")

var gived = false

func _ready():
	$Timer.connect("timeout", self, "_blink")

func _pop(player):
	if not gived:
		$PopUp.show()

func _unpop():
	$PopUp.hide()

func _on_interacted():
	if not gived:
		$Particles2D.emitting = true
		$PopUp.hide()
		gived = true
		Info._give_item(5, 20)

func _blink():
	animstate.travel("Blink")
	$Timer.wait_time = randi() %3 + 2
	$Timer.start()
