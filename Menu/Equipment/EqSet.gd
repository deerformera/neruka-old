extends Control

onready var t = $Tween
onready var Item_Refresher = preload("res://Items/item_refresher.gd")

var tex: Dictionary = {}
var current_panel
var current_selected

var movin = {
	"hButton":{"panel":"LPanel", "anchor":"anchor_top", "back_anchor":"anchor_bottom", "anchor_value":0.25, "name":"hat", "show":["cat", "hButton", "R0", "R1"]},
	"aButton":{"panel":"LPanel", "anchor":"anchor_left", "back_anchor":"anchor_right", "anchor_value":0.25, "name":"armor", "show":["cat", "aButton" , "R0", "R3"]},
	"bButton":{"panel":"RPanel", "anchor":"anchor_bottom", "back_anchor":"anchor_top", "anchor_value":-0.25, "name":"boots", "show":["cat", "bButton", "R3", "R4"]},
	"cButton":{"panel":"RPanel", "anchor":"anchor_right", "back_anchor":"anchor_left", "anchor_value":-0.25, "name":"claw", "show":["cat", "cButton", "R1", "R4"]}
}

func _ready():
	var f = File.new()
	f.open("res://Items/equipment.tres", File.READ)
	tex = parse_json(f.get_as_text())
	f.close()
	
	$LPanel/EqButton.connect("toggled", self, "_equipped", ["LPanel"])
	$RPanel/EqButton.connect("toggled", self, "_equipped", ["RPanel"])
	
	for x in $Center.get_children():
		if x.get_class() == 'TextureButton':
			x.connect("toggled", self, "_select", [x.name])
	
	for x in range(movin.size()):
		var keys = movin.keys()[x]
		for y in get_children():
			if y.name == movin[keys]["name"]:
				for z in y.get_node("Box").get_children():
					if not int(z.name) in Info.dat["player"]["eq"][y.name]["inv"]:
						z.hide()
					else:
						z.connect("toggled", self, "_slot_selected", [y.name, z.name])

# Category Selected
func _select(bol, x_name):
	t.interpolate_property($Center, movin[x_name]["anchor"], null, movin[x_name]["anchor_value"], 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	if bol == true:
		for x in $Center.get_children():
			if not x.name in movin[x_name]["show"]:
				t.interpolate_property(x, "modulate:a", null, 0, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
				t.start()
				if x.get_class() == 'TextureButton':
					x.disabled = true
		
		current_panel = get_node(movin[x_name]["panel"])
		
		var panel = movin[x_name]["panel"]
		var category = movin[x_name]["name"]
		
		get_node(panel).modulate.a = 1
		get_node(category).modulate.a = 1
		get_node(panel).show()
		get_node(category).show()
		_nuller(current_panel)
		
		for x in get_node(category).get_node("Box").get_children():
			if Info.dat["player"]["eq"][category]["equipped"] != 0:
				var selected = str(Info.dat["player"]["eq"][category]["equipped"])
				
				current_selected = [category, Info.dat["player"]["eq"][category]["equipped"]]
				
				current_panel.get_node("EqButton").disabled = false
				current_panel.get_node("EqButton").pressed = true
				current_panel.get_node("nameLabel").text = str(tex[category][selected]["name"])
				current_panel.get_node("descLabel").text = str(tex[category][selected]["desc"])
				for y in get_node(category).get_node("Box").get_children():
					if y.name == selected:
						y.pressed = true
				
				break
		
	else:
		var category = movin[x_name]["name"]
		for x in get_node(category).get_node("Box").get_children():
			x.pressed = false
		
		t.interpolate_property($Center, movin[x_name]["back_anchor"], null, 0, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
		for x in $Center.get_children():
			t.interpolate_property(x, "modulate:a", null, 1, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
			t.start()
			if x.get_class() == "TextureButton":
				x.disabled = false
		
		t.interpolate_property(current_panel, "modulate:a", null, 0, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		t.interpolate_property(get_node(category), "modulate:a", null, 0, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		yield(t, "tween_all_completed")
		current_panel.hide()
		get_node(category).hide()
		
		_nuller(current_panel)

#Category(claw, armor, boots, hat) Set
func _slot_selected(bol, category, slot_name):
	if bol == true:
		for x in get_node(category).get_node("Box").get_children():
			if x.pressed and x.name != slot_name:
				x.pressed = false
		
		if int(slot_name) == Info.dat["player"]["eq"][category]["equipped"]:
			current_panel.get_node("EqButton").pressed = true
		else:
			current_panel.get_node("EqButton").pressed = false
		
		current_selected = [category, int(slot_name)]
		
		var dat = tex[category][str(slot_name)]
		_panelling(dat["name"], "", dat["desc"])
	else:
		for x in get_node(category).get_node("Box").get_children():
			if x.pressed:
				return
		
		_nuller(current_panel)

# Equip Button
func _equipped(bol, panel_selected):
	if bol == true:
		for x in get_node(current_selected[0]).get_node("Box").get_children():
			if x.pressed and x.name == str(current_selected[1]):
				Info.dat["player"]["eq"][current_selected[0]]["equipped"] = current_selected[1]
		
	else:
		for x in get_node(current_selected[0]).get_node("Box").get_children():
			if x.pressed and x.name == str(current_selected[1]):
				Info.dat["player"]["eq"][current_selected[0]]["equipped"] = 0

func _panelling(name_text, gains_text, desc_text):
	current_panel.get_node("nameLabel").text = name_text
	current_panel.get_node("descLabel").text = desc_text
	current_panel.get_node("EqButton").disabled = false

#Emptying Panel
func _nuller(panel):
	panel.get_node("nameLabel").text = ""
	panel.get_node("descLabel").text = ""
	panel.get_node("EqButton").disabled = true
