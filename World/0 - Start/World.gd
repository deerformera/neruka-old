extends CanvasLayer

func _switch(first, second):
	var t = $Tween
	t.interpolate_property(first, "modulate:a", null, 0, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()
	yield(t, "tween_completed")
	first.hide()
	second.modulate.a = 0
	second.show()
	t.interpolate_property(second, "modulate:a", null, 1, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()

func _on_PlayButton_pressed():
	_switch($M/W1, $M/W2)

func _on_ExitButton_pressed():
	get_tree().quit()


func _on_BackButton_pressed():
	_switch($M/W2, $M/W1)


func _on_NewGame_pressed():
	var f = File.new()
	if f.file_exists("user://saves/player.tres"):
		_switch($M/W2, $M/W3)
	else:
		Info._save()
		Loader.fade(1)

func _on_LoadGame_pressed():
	var f = File.new()
	if f.file_exists("user://saves/player.tres"):
		Info._load()
		Loader.fade(6)


func _on_OverwriteNo_pressed():
	_switch($M/W3, $M/W2)

func _on_OverwriteYes_pressed():
	Info._save()
	Loader.fade(1)
