extends VBoxContainer

var src = [["claw", "res://Items/claw.tres"], ["boots", "res://Items/boots.tres"]]
var dat

func _ready():
	$Equip.connect("toggled", self, "_toggled")

func _toggled(bol):
	if bol:
		$Equip.text = "UnEquip"
	else:
		$Equip.text = "Equip"

func _contract(a, b):
	print([a, b])
