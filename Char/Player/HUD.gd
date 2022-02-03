extends CanvasLayer

var fading = false

func _physics_process(delta):
	if get_tree().paused == true:
		$C.modulate.a = 0
		$C.visible = false
		get_parent().animstate.travel("Idle")
	else:
		$C.visible = true
		var t = Tween.new()
		add_child(t)
		t.interpolate_property($C, "modulate:a", null, 1, 0.6, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		t.start()
