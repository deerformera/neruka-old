extends TextureRect

export var tex = [
	"res://Items/B-Gold.png",
	"res://Items/B-Normal.png",
	"res://UI/Rost_Gold.png"
]

func _ready():
	_refresh()

func _refresh():
	var id = get_parent().id
	var amount = get_parent().amount
	texture = load(tex[id - 1])
	$Label.text = str(amount)
