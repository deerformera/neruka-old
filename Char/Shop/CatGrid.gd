extends Control

var Catalog = preload("res://Char/Shop/Catalog.tscn")
var Itin = "res://Items/Item.tres"
var itin = {}
var current_item = []
var shopkeeper

onready var panel = $"../../Panel"

func _start(ShopKeeper):
	shopkeeper = ShopKeeper.name
	
	var f = File.new()
	f.open(Itin, File.READ)
	itin = parse_json(f.get_as_text())
	f.close()
	
	panel.get_node("Buy").connect("pressed", self, "_purchased")
	
	for x in Info.stat["shopstock"][shopkeeper].size():
		var cat = Catalog.instance()
		cat.name = str(x)
		add_child(cat)
	
	_refresh()
	
	for x in get_children():
		x.connect("toggled", self, "_select", [x.name])
	
	panel.get_node("Panel/VB/AmoSlider").editable = false
	panel.get_node("Buy").disabled = true
	panel.get_node("Name").text = ""
	panel.get_node("Desc").text = ""
	panel.get_node("Price").text = ""
	panel.get_node("Panel/VB/Amo").text = ""
	panel.get_node("Total").text = ""

func _select(bol, nama):
	var dex = int(nama)
	
	if bol == true:
		current_item = [dex, 1]
		
		var id = Info.stat["shopstock"][shopkeeper][dex][1]
		var stock = Info.stat["shopstock"][shopkeeper][dex][2]
		var price = Info.stat["shopstock"][shopkeeper][dex][3]
		
		
		panel.get_node("Buy").disabled = false
		panel.get_node("Panel/VB/AmoSlider").editable = true
		
		panel.get_node("Name").text = "Name : " + itin[str(id)]["name"]
		panel.get_node("Desc").text = "Description : " + itin[str(id)]["desc"]
		panel.get_node("Price").text = "Price : " + str(price) + " Rost"
		panel.get_node("Panel/VB/AmoSlider").max_value = stock
		panel.get_node("Panel/VB/Amo").text = "Amount To Buy : 1"
		panel.get_node("Panel/VB/AmoSlider").value = 1
		panel.get_node("Total").text = "Total Price : " + str(price) + " Rost"
		
		for x in get_children():
			if x.pressed and x.name != nama:
				x.pressed = false
				
	else:
		for x in get_children():
			if x.pressed == true:
				return
		
		for x in get_children():
			if x.pressed == false:
				panel.get_node("Buy").disabled = true
				panel.get_node("Name").text = ""
				panel.get_node("Desc").text = ""
				panel.get_node("Price").text = ""
				panel.get_node("Panel/VB/AmoSlider").scrollable = false
				panel.get_node("Panel/VB/AmoSlider").value = 0
				panel.get_node("Panel/VB/AmoSlider").max_value = 10
				panel.get_node("Panel/VB/Amo").text = ""
				panel.get_node("Total").text = ""
				return


func _amo_change(value):
	panel.get_node("Panel/VB/Amo").text = "Amount To Buy : " + str(value)
	
	current_item[1] = value
	
	var total = Info.stat["shopstock"][shopkeeper][current_item[0]][3] * value
	
	panel.get_node("Total").text = "Total Price : " + str(total) + " Rost"


func _purchased():
	var id = Info.stat["shopstock"][shopkeeper][current_item[0]][1]
	var amount = current_item[1]
	var total = Info.stat["shopstock"][shopkeeper][current_item[0]][3] * amount
	
	var tradeable = false
	
	for x in Info.stat["player"]["inv"]:
		if x[0] == 5 and x[1] - total >= 0:
			x[1] -= total
			Info.stat["shopstock"][shopkeeper][current_item[0]][2] -= amount
			_refresh()
			tradeable = true
			
	if !tradeable:
		find_parent("Shop").get_node("M2/BG/M/PopUp").show()
		panel.get_node("Buy").disabled = true
		yield(get_tree().create_timer(0.5), "timeout")
		panel.get_node("Buy").disabled = false
		find_parent("Shop").get_node("M2/BG/M/PopUp").hide()
	else:
		Info._give_item(id, amount)

func _refresh():
	for x in get_children():
		var id = Info.stat["shopstock"][shopkeeper][int(x.name)][1]
		var stock = Info.stat["shopstock"][shopkeeper][int(x.name)][2]
		var price = Info.stat["shopstock"][shopkeeper][int(x.name)][3]
		
		if stock <= 0:
			x.get_node("VB/Stock").text = "Out Of Stock!"
			x.disabled = true
			x.pressed = false
		else:
			x.get_node("VB/Stock").text = "Stock : " + str(stock)
		
		x.get_node("VB/TextureRect").texture = load(itin[str(id)]["tex"])
		x.get_node("VB/Name").text = itin[str(id)]["name"]
		x.get_node("VB/Price").text = "Price : " + str(price) + " Rost"
