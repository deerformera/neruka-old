extends Control

var ItemTexture = "res://Items/Item.tres"
var tex = {}

func _ready():
	var f = File.new()
	f.open(ItemTexture, File.READ)
	tex = parse_json(f.get_as_text())
	f.close()
	
	_refresh()

func _refresh():
	var id = get_parent().id
	var amount = get_parent().amount
	$M/Rect.texture = load(tex[str(id)]["tex"])
	$Label.text = str(amount)
