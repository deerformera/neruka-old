extends Area2D

var entered = false

func _on_Door_body_entered(body):
	entered = true

func _on_Door_body_exited(body):
	entered = false

func _input(event):
	if Input.is_action_just_pressed("Interact") and entered == true and $"../Sign".writed == true:
		Info.stat["scene"] = "World"
		Info._save()
		Loader.fade(6)
