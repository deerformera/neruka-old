extends CanvasLayer

onready var Tex = "res://Items/equipment.tres"
var tex = {}

func _ready():
	var f = File.new()
	f.open(Tex, File.READ)
	tex = parse_json(f.get_as_text())
	
	$M2/BG/M/VB/HB/LVB/Namebar.text = Info.stat["player"]["name"]
	$M2/BG/M/VB/HB/LVB/Healthbar.text = str(Info.stat["player"]["health"])
	$M2/BG/M/VB/HB/S/RVB/Worldbar.text = Info.stat["player"]["place"]
	
	if Info.stat["player"]["eq"]["claw"]["equipped"] != 0:
		$M2/BG/M/VB/HB/S/RVB/ClawEqbar.text = tex["claw"][str(Info.stat["player"]["eq"]["claw"]["equipped"])]["name"]
	
	if Info.stat["player"]["eq"]["boots"]["equipped"] != 0:
		$M2/BG/M/VB/HB/S/RVB/BootsEqbar.text = tex["boots"][str(Info.stat["player"]["eq"]["boots"]["equipped"])]["name"]
	
	
	_tweented()

func _tweented():
	
	$M2.visible = false
	$M1.anchor_left = 0.25
	$M1.anchor_right = 0.75
	$M2.anchor_bottom = 0.5
	$M2/BG/M/VB/Title/StatLabel.percent_visible = 0
	
	var t = Tween.new()
	add_child(t)
	t.interpolate_property($M1, "anchor_left", null, 0, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.interpolate_property($M1, "anchor_right", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()
	yield(t, "tween_completed")
	$M2.visible = true
	t.interpolate_property($M2, "anchor_bottom", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.interpolate_property($M2/BG/M/VB/Title/StatLabel, "percent_visible", 0, 1, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	t.start()


func _on_CloseButton_pressed():
	get_tree().paused = false
	queue_free()
