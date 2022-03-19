extends CanvasLayer

func _ready():
	_tweented()

func _tweented():
	
	$M2.visible = false
	$M1.anchor_left = 0.25
	$M1.anchor_right = 0.75
	$M2.anchor_bottom = 0.5
	$M2/BG/M/VB/Title/EqLabel.percent_visible = 0
	
	var t = Tween.new()
	add_child(t)
	t.interpolate_property($M1, "anchor_left", null, 0, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.interpolate_property($M1, "anchor_right", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()
	yield(t, "tween_completed")
	$M2.visible = true
	t.interpolate_property($M2, "anchor_bottom", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.interpolate_property($M2/BG/M/VB/Title/EqLabel, "percent_visible", null, 1, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	t.start()


func _on_CloseButton_pressed():
	get_tree().paused = false
	get_tree().get_nodes_in_group("Player")[0].get_node("EqManager")._refresh()
	queue_free()

