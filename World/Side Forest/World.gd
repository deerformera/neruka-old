extends YSort

var pos = []

func _ready():
	for x in get_children():
		if x.get_class() == "StaticBody2D":
			pos.append(x.global_position)
			print(pos)
