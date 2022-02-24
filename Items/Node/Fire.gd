extends AnimatedSprite

var count = 0

func _ready():
	var t = Timer.new()
	t.autostart = true
	t.wait_time = 1
	t.connect("timeout", self, "_burn")
	add_child(t)

func _burn():
	if get_parent().health >= 0:
		get_parent()._attacked(2)
	count += 1
	
	if count >= 2:
		queue_free()
