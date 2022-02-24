extends Node

var damage: int = 10
var speed: int = 10

var boots = {
	"tex":"res://Char/Player/JumpRay.tscn"
	}

func refresh():
	var f = File.new()
	f.open("res://Items/equipment.tres", File.READ)
	var tex = parse_json(f.get_as_text())
	f.close()
	
	var boots_equipped = Info.stat["player"]["eq"]["boots"]["equipped"]
	
	if boots_equipped == 0:
		return
	
	speed = int(tex["boots"][str(boots_equipped)]["speed"])
