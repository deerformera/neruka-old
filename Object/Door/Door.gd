extends StaticBody2D


func _pop(player):
	if Input.is_action_just_pressed("Interact") and $"../Sign".writed == true:
		Info._save()
		Loader.fade_to(3)

func _unpop():
	pass
