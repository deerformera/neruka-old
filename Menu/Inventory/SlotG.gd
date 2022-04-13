extends Control

onready var slot = preload("res://Menu/Inventory/Slot.tscn")
onready var item = preload("res://Menu/Inventory/Item.tscn")
onready var tw = $"../../../../../Tween"

var tex_path = "res://Items/item.tres"
var tex = {}
var selected = []

func _ready():
	var f = File.new()
	f.open(tex_path, File.READ)
	tex = parse_json(f.get_as_text())
	f.close()
	
	for x in Info.dat["player"]["inv"].size():
		var sloti = slot.instance()
		sloti.name = str(x)
		add_child(sloti)
	
	for x in get_children():
		x.connect("toggled", self, "_switch", [x.name])
		if Info.dat["player"]["inv"][int(x.name)][0] != 0:
			x.add_child(item.instance())
	
	_refresh()

func _switch(bol, xname):
	if bol == true:
		selected.append(int(xname))
		
		if Info.dat["player"]["inv"][selected[0]][0] == 0:
			for x in get_children():
				x.pressed = false
			
			selected.clear()
			return
		
		if selected.size() >= 2:
			var first_selected = Info.dat["player"]["inv"][selected[0]]
			var second_selected = Info.dat["player"]["inv"][selected[1]]
		
			if second_selected[0] == 0:
				Info.dat["player"]["inv"][selected[1]] = first_selected
				Info.dat["player"]["inv"][selected[0]] = [0, 0]
				tw.interpolate_property(get_child(selected[0]).get_child(0), "global_position", null, get_child(selected[1]).rect_global_position, 0.05, Tween.TRANS_EXPO, Tween.EASE_OUT)
				tw.start()
				
			elif second_selected[0] == first_selected[0]:
				if selected[0] == selected[1]:
					selected.resize(1)
					return
					
				Info.dat["player"]["inv"][selected[1]][1] += first_selected[1]
				Info.dat["player"]["inv"][selected[0]] = [0, 0]
				tw.interpolate_property(get_child(selected[0]).get_child(0), "global_position", null, get_child(selected[1]).rect_global_position, 0.05, Tween.TRANS_EXPO, Tween.EASE_OUT)
				tw.start()
				
			elif second_selected[0] != 0:
				for x in range(Info.dat["player"]["inv"].size()):
					if x == selected[0]:
						Info.dat["player"]["inv"][x] = second_selected
					if x == selected[1]:
						Info.dat["player"]["inv"][x] = first_selected
				
				tw.interpolate_property(get_child(selected[0]).get_child(0), "global_position", null, get_child(selected[1]).rect_global_position, 0.05, Tween.TRANS_EXPO, Tween.EASE_OUT)
				tw.interpolate_property(get_child(selected[1]).get_child(0), "global_position", null, get_child(selected[0]).rect_global_position, 0.05, Tween.TRANS_EXPO, Tween.EASE_OUT)
				tw.start()
			
			yield(tw, "tween_all_completed")
			_refresh()
			for x in get_children():
				x.pressed = false
	else:
		selected.clear()

func _refresh():
	for x in get_children():
		var itin = Info.dat["player"]["inv"][int(x.name)]
		
		if x.get_child_count() != 0:
			x.get_child(0).queue_free()
			if itin[0] != 0:
				var itemi = item.instance()
				itemi.get_node("Control/Icon").texture = load(tex[str(itin[0])]["tex"])
				itemi.get_node("Control/Label").text = str(itin[1])
				x.add_child(itemi)
		else:
			if itin[0] != 0:
				var itemi = item.instance()
				itemi.get_node("Control/Icon").texture = load(tex[str(itin[0])]["tex"])
				itemi.get_node("Control/Label").text = str(itin[1])
				x.add_child(itemi)
