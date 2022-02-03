extends StaticBody2D

var gived = false

func _pop(player):
	if gived == false:
		$PopUp.show()
		if Input.is_action_just_pressed("Interact"):
			$Particles2D.emitting = true
			$PopUp.hide()
			gived = true
			Info._give_item(3, 10)

func _unpop():
	$PopUp.hide()
