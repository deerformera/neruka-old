extends TextureRect

func _ready():
	connect("mouse_entered", self, "_entered")
	connect("mouse_exited", self, "_exited")


func _entered():
	$Label.text = self.name
	$Rect.visible = true

func _exited():
	$Label.text = ""
	$Rect.visible = false
