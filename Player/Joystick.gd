extends Control

signal moving

var center = Vector2()
var pos = Vector2()

func _ready():
	center = ($JSRect.rect_position + Vector2(160, 160))
	$JSC.position = center

func _input(event):
	if event is InputEventScreenDrag:
		if $JSRect/JSTSB.is_pressed():
			emit_signal("moving")
			pos = (event.position - center).clamped(120)
			$JSC.position = pos + center
			pos = pos.normalized()
	if event is InputEventScreenTouch:
		if not $JSRect/JSTSB.is_pressed():
			pos = Vector2()
			$JSC.position = center
