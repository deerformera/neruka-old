extends StaticBody2D

var opened = false

func _ready():
	$PopUp.hide()

func _pop(player):
	if not opened:
		$PopUp.show()

func _on_interacted():
	if not opened:
		$PopUp.hide()
		opened = true
		Info._give_eq("boots", 3)
		$Particles2D.emitting = true
		$Sprite.frame = 1

func _unpop():
	$PopUp.hide()
