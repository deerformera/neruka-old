extends HBoxContainer

var src = "res://Items/claw.tres"
var dat = {}
var equipped
signal contract

func _ready():
	for x in $S/VB.get_children():
		x.connect("toggled", self, "_select", [x.name])
	
	get_parent().get_node("RightPanel/Equip").connect("toggled", self, "_equipped")
	
	var f = File.new()
	f.open(src, File.READ)
	dat = parse_json(f.get_as_text())
	f.close()

func _start(a, b, c):
	
	if c == true:
		connect("contract", get_parent().get_node(b), "_contract")
		emit_signal("contract", name, c)
		
		if a == name:
			equipped = Info.stat["eq"][name]["equipped"]
			
			if equipped != 0:
				get_parent().get_node("RightPanel/Name").text = "Name : " + dat[str(equipped)]["name"]
				get_parent().get_node("RightPanel/Value").text = "Damage : " + dat[str(equipped)]["damage"]
				get_parent().get_node("RightPanel/Tier").text = "Tier : " + dat[str(equipped)]["tier"]
				get_parent().get_node("RightPanel/Desc").text = "Description : " + dat[str(equipped)]["desc"]
				get_parent().get_node("RightPanel/Equip").disabled = false
				get_parent().get_node("RightPanel/Equip").pressed = true
				
				for x in $S/VB.get_children():
					x.pressed = false
					if x.name == str(equipped):
						x.pressed = true
	else:
		pass
		emit_signal("contract", name, c)
		disconnect("contract", get_parent().get_node(a), "_contract")

		for x in $S/VB.get_children():
			x.pressed = false

func _select(bol, nama):
	if bol == true:
		for x in $S/VB.get_children():
			if x.pressed and x.name != nama:
				x.pressed = false
		
		equipped = Info.stat["eq"][name]["equipped"]
		
		get_parent().get_node("RightPanel/Name").text = "Name : " + dat[nama]["name"]
		get_parent().get_node("RightPanel/Value").text = "Damage : " + dat[nama]["damage"]
		get_parent().get_node("RightPanel/Tier").text = "Tier : " + dat[nama]["tier"]
		get_parent().get_node("RightPanel/Desc").text = "Description : " + dat[nama]["desc"]
		get_parent().get_node("RightPanel/Equip").disabled = false
		
		if str(equipped) == nama:
			get_parent().get_node("RightPanel/Equip").pressed = true
		else:
			get_parent().get_node("RightPanel/Equip").pressed = false
	
	else:
		get_parent().get_node("RightPanel/Name").text = ""
		get_parent().get_node("RightPanel/Value").text = ""
		get_parent().get_node("RightPanel/Tier").text = ""
		get_parent().get_node("RightPanel/Desc").text = ""
		get_parent().get_node("RightPanel/Equip").disabled = true

func _equipped(a):
	if a == false:
		for x in $S/VB.get_children():
			if x.pressed:
				if x.name != str(equipped):
					return
				
				Info.stat["eq"][name]["equipped"] = 0
				
				equipped = Info.stat["eq"][name]["equipped"]
	
	if a == true:
		for x in $S/VB.get_children():
			if x.pressed:
				if x.name != str(equipped):
					Info.stat["eq"][name]["equipped"] = int(x.name)
					equipped = Info.stat["eq"][name]["equipped"]
