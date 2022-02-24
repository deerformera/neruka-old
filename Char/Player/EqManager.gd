extends Node2D

var tex: Dictionary = {}

var speed = 10
var damage = 10

var claw_scene = {
	"0":"res://Items/Node/C0.tscn",
	"1":"res://Items/Node/C1.tscn",
	"2":"res://Items/Node/C2.tscn",
	"3":"res://Items/Node/C3.tscn",
	"4":"res://Items/Node/C4.tscn"
}

var boots_scene = {
	"2":"res://Items/Node/B2.tscn",
	"3":"res://Items/Node/B3.tscn"
}

func _ready():
	var f = File.new()
	f.open("res://Items/equipment.tres", File.READ)
	tex = parse_json(f.get_as_text())
	f.close()
	_refresh()
	for x in tex["claw"]:
		print([tex["claw"][x]["desc"], tex["claw"][x]["name"]])

func _refresh():
	_refresh_boots()
	_refresh_claw()

func _refresh_claw():
	var equipped = Info.stat["player"]["eq"]["claw"]["equipped"]
	if equipped == 0:
		damage = 10
	else:
		damage = int(tex["claw"][str(equipped)]["damage"])
	
	if get_node("Claw") != null:
		get_node("Claw").queue_free()
		remove_child(get_node("Claw"))
	
	var claw_ins = load(claw_scene[str(equipped)]).instance()
	claw_ins.name = "Claw"
	add_child(claw_ins)

func _refresh_boots():
	var equipped = Info.stat["player"]["eq"]["boots"]["equipped"]
	if equipped == 0:
		speed = 10
		if get_node("Boots") != null:
			get_node("Boots").queue_free()
	else:
		speed = int(tex["boots"][str(equipped)]["speed"])
		var boots_ins = load(boots_scene[str(equipped)]).instance()
		
		if get_node("Boots") != null:
			get_node("Boots").queue_free()
			remove_child(get_node("Boots"))
		
		add_child(boots_ins)
	
	get_parent().speed = speed
