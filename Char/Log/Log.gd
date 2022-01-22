extends CanvasLayer

var Log = "res://Char/Log/log.tres"
var text = {}

func _ready():
	var f = File.new()
	f.open(Log, File.READ)
	text = parse_json(f.get_as_text())
	f.close()

func _start(nm):
	$M2/BG/M/VB/Name.text = nm
	
	if Info.stat["contact"].has("Rot"):
		pass
	else:
		if text[nm]["000"]["type"] == "question":
			$M2/BG/M/VB/Desc/Log.show()
			$M2/BG/M/VB/Desc/Log.text = text[nm]["000"]["text"]
			
		
	
	_tweented()


func _input(event):
	if Input.is_action_just_pressed("Interact"):
		print()

func _tweented():
	
	$M1.visible = true
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

