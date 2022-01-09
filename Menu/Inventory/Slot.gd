extends TextureButton

signal switch

var m = preload("res://UI/Outline.tres")
var i = preload("res://Menu/Inventory/Item.tscn")

onready var id = Info.stat["inv"][int(name)][0]
onready var amount = Info.stat["inv"][int(name)][1]
onready var p = get_parent()

func _ready():
	connect("toggled", self, "_select")
	if id != 0:
		add_child(i.instance())

func _select(bol):
	if bol == true:
		if name in p.selected:
			return
		
		p.selected.append(name)
		p.selected_id.append(id)
		p.selected_amount.append(amount)

	if p.selected.size() >= 2:
		emit_signal("switch")

func _refresh():
	if id == 0:
		if get_node("Item") != null:
			get_node("Item").queue_free()

	else:
		if get_node("Item") == null:
			add_child(i.instance())
		get_node("Item")._refresh()

