extends GridContainer

onready var slot = preload("res://Menu/Inventory/Slot.tscn")

var selected = []
var selected_id = []
var selected_amount = []

func _ready():
	for x in range(Info.stat["inv"].size()):
		var s = slot.instance()
		s.name = str(x)
		add_child(s)
	
	for x in get_children():
		x.connect("switch", self, "_switch")


func _switch():
	
	if get_node(selected[0]).id != 0:
		
		if selected_id[0] == selected_id[1]:
			get_node(selected[0]).id = 0
			get_node(selected[0]).amount = 0
			get_node(selected[1]).amount += selected_amount[0]
		else:
			get_node(selected[0]).id = selected_id[1]
			get_node(selected[1]).id = selected_id[0]
			get_node(selected[0]).amount = selected_amount[1]
			get_node(selected[1]).amount = selected_amount[0]

		for x in get_children():
			x._refresh()

	Info.stat["inv"] = []
	selected = []
	selected_id = []
	selected_amount = []
	for x in get_children():
		Info.stat["inv"].append([x.id, x.amount])
		x.pressed = false
