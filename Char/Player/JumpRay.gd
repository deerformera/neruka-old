extends RayCast2D

signal jump

var vec = Vector2()
var allvec = [[Vector2(-10,0), 20], [Vector2(10,0), 20], [Vector2(0,10), 40], [Vector2(0,-10), 10]]

func _ready():
	connect("jump", get_parent(), "_jump")

func _physics_process(delta):
	ray_enable()
	rotation = vec.angle()
	
	if is_colliding():
		var dect = get_collider()
		if dect.name == "JumpCliff":
			if Input.is_action_just_pressed("Interact"):
				emit_signal("jump")

func ray_enable():
	vec = $"..".vec
	
	for x in allvec:
		if x[0] == vec:
			cast_to.x = x[1]
			enabled = true
			return
		else:
			enabled = false

