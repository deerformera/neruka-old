extends Sprite

func _ready():
	var t = Timer.new()
	t.wait_time = 1
	t.autostart = true
	t.one_shot = true
	t.connect("timeout", self, "_free")
	add_child(t)
	
	get_parent().get_node("Sprite").modulate = Color.aqua
	for x in get_parent().get_children():
		if x.get_class() == "AnimationTree":
			x.active = false

func _free():
	for x in get_parent().get_children():
		if x.get_class() == "AnimationTree":
			x.active = true
	
		if x.name == "Sprite":
			get_parent().get_node("Sprite").modulate = Color.white
	$Particles2D.emitting = true
	self_modulate.a = 0
	yield(get_tree().create_timer(2), "timeout")
	queue_free()
