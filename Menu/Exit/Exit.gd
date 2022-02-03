extends CanvasLayer

func _ready():
	$M2/BG/M/VB/SurityLabel.percent_visible = 0
	_tweented()

func _tweented():
	var t = Tween.new()
	add_child(t)
	$M2.visible = false
	$M1.anchor_left = 0.25
	$M1.anchor_right = 0.75
	$M2.anchor_bottom = 0.5
	t.interpolate_property($M1, "anchor_left", null, 0, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.interpolate_property($M1, "anchor_right", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()
	yield(t, "tween_completed")
	$M2.visible = true
	t.interpolate_property($M2, "anchor_bottom", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.interpolate_property($M2/BG/M/VB/SurityLabel, "percent_visible", 0, 1, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	t.start()


func _on_Yes_pressed():
	get_tree().quit()

func _on_No_pressed():
	get_tree().paused = false
	queue_free()
