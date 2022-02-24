extends HBoxContainer

onready var t = $Tween
onready var matslot = preload("res://Menu/Craft/MaterialSlot.tscn")
onready var slot = preload("res://Menu/Craft/Slot.tscn")

var tex_path = "res://Items/item.tres"
var tex
var craftable = false
var craftable_arr = []
var temp_x

func _ready():
	var f = File.new()
	f.open(tex_path, File.READ)
	tex = parse_json(f.get_as_text())
	f.close()
	
	$Panel.modulate.a = 0
	
	$Panel/CraftButton.connect("pressed", self, "_craft")
	
	for x in Info.stat["player"]["knowledge"]:
		get_node("List/Primer").get_child(int(tex[str(x)]["category"])).show()
		var slot_ins = slot.instance()
		slot_ins.icon = load(tex[str(x)]["tex"])
		slot_ins.hide()
		slot_ins.name = str(x)
		$List/Sekunder.add_child(slot_ins)
		slot_ins.connect("toggled", self, "_sekunder", [str(x)])
	
	for x in $List/Primer.get_children():
		x.connect("toggled", self, "_primer", [x.name])

func _primer(bol, x_name):
	if bol:
		for x in $List/Primer.get_children():
			if x.pressed and x.name != x_name:
				x.pressed = false
		
		for x in Info.stat["player"]["knowledge"]:
			if tex[str(x)]["category"] == x_name:
				$List/Sekunder.get_node(str(x)).show()
			else:
				$List/Sekunder.get_node(str(x)).hide()
		
		if $List/Sekunder.visible == false:
			t.interpolate_property($List/Primer, "anchor_right", null, -1.25, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
			t.start()
			yield(t, "tween_completed")
			$List/Sekunder.show()
			$List/Primer.anchor_right = 0
			$List/Primer.anchor_left = 0
	else:
		for x in $List/Sekunder.get_children():
			x.pressed = false
			x.hide()
		
		for x in $List/Primer.get_children():
			if x.pressed and x.name != x_name:
				return
		
		_panelling(false)
		
		$List/Sekunder.hide()
		$List/Primer.anchor_right = -1.25
		t.interpolate_property($List/Primer, "anchor_left", null, 0, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
		t.start()

func _sekunder(bol, x_name):
	if bol == true:
		for x in $List/Sekunder.get_children():
			if x.pressed and x.name != x_name:
				if $Panel/ReqItem/SlotGrid.get_child_count() != 0:
					for y in $Panel/ReqItem/SlotGrid.get_children():
						y.queue_free()
				x.pressed = false
		
		_panelling(true)
		
		$Panel/Label.text = tex[x_name]["name"]
		temp_x = x_name
		
		for x in tex[x_name]["material"].size():
			var matslot_ins = matslot.instance()
			var mat = tex[x_name]["material"][x]
			matslot_ins.get_node("VB/Name").text = tex[str(mat[0])]["name"]
			matslot_ins.get_node("VB/Icon").texture = load(tex[str(mat[0])]["tex"])
			matslot_ins.get_node("VB/Amount").text = str(mat[1])
			$Panel/ReqItem/SlotGrid.add_child(matslot_ins)
		
		_refresh()
		
	else:
		craftable = false
		
		for x in $List/Sekunder.get_children():
			if x.pressed and x.name != x_name:
				return
		
		_panelling(false)

func _refresh():
	craftable_arr = []
	craftable = false
	
	for x in tex[temp_x]["material"].size():
		var mat = tex[temp_x]["material"][x]
		for y in Info.stat["player"]["inv"]:
			if y[0] == mat[0] and y[1] >= mat[1]:
				craftable_arr.append(y[0])
				break
				
	if craftable_arr.size() == tex[temp_x]["material"].size():
		craftable = true
	
	if craftable:
		$Panel/CraftButton.disabled = false
	else:
		$Panel/CraftButton.disabled = true

func _craft():
	for x in tex[temp_x]["material"]:
		for y in Info.stat["player"]["inv"]:
			if y[0] == x[0]:
				y[1] -= x[1]
	Info._give_item(int(temp_x), 1)
	Info._null_checker()
	_refresh()

func _panelling(bol):
	if bol == true:
		t.interpolate_property($Panel, "modulate:a", null, 1, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		t.start()
		$Panel/CraftButton.disabled = false
		
	if bol == false:
		t.interpolate_property($Panel, "modulate:a", null, 0, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		t.start()
		yield(t, "tween_completed")
		$Panel/Label.text = ""
		$Panel/CraftButton.disabled = true
		if $Panel/ReqItem/SlotGrid.get_child_count() != 0:
			for x in $Panel/ReqItem/SlotGrid.get_children():
				x.queue_free()
