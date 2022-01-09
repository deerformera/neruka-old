extends RayCast2D

signal jump

var vec = Vector2()

func _ready():
	connect("jump", get_parent(), "_jump")
	print("added")

func _physics_process(delta):
	ray_enable()
	rotation = vec.angle()

	if is_colliding():
		var dect = get_collider()
		if dect.name == "JumpCliff":
			if Input.is_action_just_pressed("Interact"):
				emit_signal("jump")

func ray_enable():

	vec = get_parent().vec

	if vec == Vector2(-10, 0):
		enabled = true
	elif vec == Vector2(10, 0):
		enabled = true
	elif vec == Vector2(0, 10):
		enabled = true
	elif vec == Vector2(0, -10):
		enabled = true
	else:
		enabled = false

