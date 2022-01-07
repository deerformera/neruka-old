extends Control

signal contract
var equipped


func _ready():
	connect("contract", get_parent().get_node("RightPanel"), "_contract")
	
	for x in $S/SS.get_children():
		x.connect("toggled", self, "_switch", [x.name])

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

func _equipped(bol):
	pass
