extends Control

signal contract
var equipped

var jumpray = preload("res://Char/Player/JumpRay.tscn")

func _ready():
	connect("contract", get_parent().get_node("RightPanel"), "_contract")
	
	for x in $S/SS.get_children():
		x.connect("toggled", self, "_switch", [x.name])
		
		if int(x.name) in Info.stat["eq"][name]["inv"]:
			x.visible = true
		else:
			x.visible = false



func _start(bol, nama):
	if name == nama:
		if bol == true:
			
			equipped = Info.stat["eq"][name]["equipped"]
			for x in $S/SS.get_children():
				if equipped != 0 and x.name == str(equipped):
					x.pressed = true
			
			emit_signal("contract", bol, nama)
		else:
			emit_signal("contract", bol, nama)
			
			for x in $S/SS.get_children():
				x.pressed = false

func _switch(bol, nama):
	equipped = Info.stat["eq"][name]["equipped"]
	if bol == true:
		for x in $S/SS.get_children():
			if x.pressed and x.name != nama:
				x.pressed = false
		
		get_parent().get_node("RightPanel")._switched(nama, name)
	else:
		get_parent().get_node("RightPanel")._nuller()

func _equip(bol, nama):
	
	if bol == true:
		Info.stat["eq"][name]["equipped"] = int(nama)
		_item_stat()
	else:
		Info.stat["eq"][name]["equipped"] = 0
		_item_stat()

func _item_stat():
	equipped = Info.stat["eq"][name]["equipped"]
	
	if name == "boots":
		if equipped == 3:
			if get_tree().root.get_node("World/Player/JumpRay") == null:
				get_tree().root.get_node("World/Player").add_child(jumpray.instance())
		else:
			if get_tree().root.get_node("World/Player/JumpRay") != null:
				get_tree().root.get_node("World/Player/JumpRay").queue_free()
