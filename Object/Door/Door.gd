extends StaticBody2D

func _pop(player):
	pass

func _on_interacted():
	if $"../Sign".writed:
		Info._save()
		Loader.fade_to(3)

func _unpop():
	pass
