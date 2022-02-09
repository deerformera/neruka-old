extends VBoxContainer

var src = [
	["claw", "res://Items/claw.tres", "Damage"], 
	["boots", "res://Items/boots.tres", "Speed"]
	]

var value
var dat

signal equip

func _contract(bol, nama):
	if bol == true:
		
		$Equip.connect("toggled", self, "_toggled", [nama])
		connect("equip", get_parent().get_node(nama), "_equip")
		
		for x in src:
			if x[0] == nama:
				value = x[2]
				
				
				var f = File.new()
				f.open(x[1], File.READ)
				dat = parse_json(f.get_as_text())
				print(dat)
				
				var equipped = Info.stat["player"]["eq"][nama]["equipped"]
				
				if equipped != 0:
					$Name.text = "Name : " + dat[str(equipped)]["name"]
					$Value.text = value + " : " + dat[str(equipped)][value]
					$Tier.text = "Tier : " + dat[str(equipped)]["tier"]
					$Desc.text = "Description : " + dat[str(equipped)]["desc"]
					$Equip.disabled = false
					$Equip.pressed = true
				
				
		
	else:
		_nuller()
		$Equip.disconnect("toggled", self, "_toggled")
		disconnect("equip", get_parent().get_node(nama), "_equip")

func _toggled(bol, nama):
	
	var equipped = Info.stat["player"]["eq"][nama]["equipped"]
	var current_node = get_parent().get_node(nama)
	
	if bol == true:
		$Equip.text = "UnEquip"
		for x in current_node.get_node("S/SS").get_children():
			if x.pressed:
				if x.name != str(equipped):
					emit_signal("equip", bol, x.name)

	else:
		$Equip.text = "Equip"
		for x in current_node.get_node("S/SS").get_children():
			if x.pressed:
				if x.name == str(equipped):
					emit_signal("equip", bol, x.name)

func _switched(btn, nama):
	var equipped = Info.stat["player"]["eq"][nama]["equipped"]
	
	if dat == null:
		return
	
	$Name.text = "Name : " + dat[btn]["name"]
	$Value.text = value + " : " + dat[btn][value]
	$Tier.text = "Tier : " + dat[btn]["tier"]
	$Desc.text = "Description : " + dat[btn]["desc"]
	$Equip.disabled = false
	
	if int(btn) == equipped:
		$Equip.pressed = true
	else:
		$Equip.pressed = false

func _nuller():
	$Name.text = ""
	$Value.text = ""
	$Tier.text = ""
	$Desc.text = ""
	$Equip.disabled = true


