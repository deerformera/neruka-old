extends VBoxContainer

var src = [
	["claw", "res://Items/claw.tres", "Damage"], 
	["boots", "res://Items/boots.tres", "Speed"]
	]

var value
var dat

func _contract(bol, nama):
	$Equip.connect("toggled", get_parent().get_node(nama), "_equipped")
	if bol == true:
		for x in src:
			if x[0] == nama:
				value = x[2]
				
				var f = File.new()
				f.open(x[1], File.READ)
				dat = parse_json(f.get_as_text())
				
				var equipped = Info.stat["eq"][nama]["equipped"]
				
				if equipped != 0:
					$Name.text = "Name : " + dat[str(equipped)]["name"]
					$Value.text = value + " : " + dat[str(equipped)][value]
					$Tier.text = "Tier : " + dat[str(equipped)]["tier"]
					$Desc.text = "Description : " + dat[str(equipped)]["desc"]
					$Equip.disabled = false
					$Equip.pressed = true
	else:
		_nuller()

func _toggled(bol, nama):
	if bol == true:
		$Equip.text = "UnEquip"
		
		for x in get_parent().get_node(nama).get_node("S/SS").get_children():
			print(x)
		
	else:
		$Equip.text = "Equip"

func _switched(btn, nama):
	var equipped = Info.stat["eq"][nama]["equipped"]
	
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

