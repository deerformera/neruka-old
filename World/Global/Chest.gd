extends StaticBody2D

var opened = false

func _ready():
	$PopUp.hide()

func _pop(player):
	
	if opened == false:
		$PopUp.show()
		
		if Input.is_action_just_pressed("Interact"):
			opened = true
			Info._give_eq("boots", 3)
			$CPUParticles2D.emitting = true
			$Sprite.frame = 1


func _unpop():
	$PopUp.hide()
