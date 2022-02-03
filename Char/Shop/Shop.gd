extends CanvasLayer

var body

func _identification(Body):
	$M2/BG/M/VB/HB/S/CatG._start(Body)
	body = Body
	
	$M2/BG/M/PopUp.hide()
	_tweented()

func _tweented():
	$M2.visible = false
	$M1.anchor_left = 0.25
	$M1.anchor_right = 0.75
	$M2.anchor_bottom = 0.5

	var t = Tween.new()
	add_child(t)
	t.interpolate_property($M1, "anchor_left", null, 0, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.interpolate_property($M1, "anchor_right", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()
	yield(t, "tween_completed")
	$M2.visible = true
	t.interpolate_property($M2, "anchor_bottom", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()


func _on_CloseButton_pressed():
	body._conversation_ended()
	queue_free()


func _on_Button_pressed():
	$M2/BG/M/PopUp.hide()
