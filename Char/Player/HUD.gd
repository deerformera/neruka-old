extends CanvasLayer

var fading = false

func _physics_process(delta):
	
	if get_tree().paused == true:
		$C.visible = false
		get_parent().animstate.travel("Idle")
	else:
		$C.visible = true
		var t = Tween.new()
		add_child(t)
		t.start()
		t.queue_free()

