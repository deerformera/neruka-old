extends TouchScreenButton

func _ready():
	connect("pressed", self, "_pressed")
	connect("released", self, "_released")
	modulate.a = 0.8

func _pressed():
	find_parent("Menu").selected = int(get_parent().name)
	find_parent("Menu").selecting = true
	modulate.a = 1

func _released():
	modulate.a = 0.8
