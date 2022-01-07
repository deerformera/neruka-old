extends GridContainer

signal start
var start = false

var type_pos = [
	["B1", "hat", "LeftPanel"], 
	["B2", "armor", "LeftPanel"], 
	["B3", "claw", "RightPanel"], 
	["B4", "boots", "RightPanel"]
]

var ar = {
	"hat":{
		"node":["C3", "B4", "C4", "B3", "B2"],
		"anc":["anchor_top", "anchor_bottom", 0.25]
	},
	
	"boots":{
		"node":["C1", "B1", "C2", "B2", "B3"],
		"anc":["anchor_bottom", "anchor_top", -0.25],
	},
	
	"claw":{
		"node":["C1", "B1", "B2", "C4", "B4"],
		"anc":["anchor_right", "anchor_left", -0.25],
	},
	
	"armor":{
		"node":["B1", "C2", "B3", "B4", "C3"],
		"anc":["anchor_left", "anchor_right", 0.25],
	}
}

var t


func _ready():
	for x in get_children():
		if x.get_class() == "TextureButton":
			x.connect("toggled", self, "_check_pos", [x.name])
	
	for x in get_parent().get_children():
		if x.name != "Grid":
			x.visible = false
	
	for x in type_pos:
		connect("start", get_parent().get_node(x[1]), "_start")

func _tweented(a, b, c, d, e):
	t = Tween.new()
	add_child(t)
	t.interpolate_property(a, b, c, d, e, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()

func _check_pos(a, b):
	
	for x in type_pos:
		if b in x[0]:
			for y in ar[x[1]]["node"]:
				if get_node(y).get_class() == "TextureButton":
					get_node(y).disabled = a
				
				if a == true:
					_tweented(get_node(y), "self_modulate:a", null, 0, 0.2)
					_tweented(self, ar[x[1]]["anc"][0], 0, ar[x[1]]["anc"][2], 0.25)
				else:
					_tweented(get_node(y), "self_modulate:a", null, 1, 0.2)
					_tweented(self, ar[x[1]]["anc"][1], null, 0, 0.25)
			
			if a == true:
				emit_signal("start", a, x[1])
				
				_tweented(get_parent().get_node(x[1]), "modulate:a", 0, 1, 0.2)
				_tweented(get_parent().get_node(x[2]), "modulate:a", 0, 1, 0.2)
				get_parent().get_node(x[1]).visible = true
				get_parent().get_node(x[2]).visible = true
			else:
				emit_signal("start", a, x[1])
				
				_tweented(get_parent().get_node(x[1]), "modulate:a", 1, 0, 0.2)
				_tweented(get_parent().get_node(x[2]), "modulate:a", 1, 0, 0.2)
				yield(t, "tween_all_completed")
				get_parent().get_node(x[1]).visible = false
				get_parent().get_node(x[2]).visible = false
