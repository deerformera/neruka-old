extends RayCast2D

signal jump
var jumpable = true
var vec = Vector2()
var vec_config = {Vector2(0, -10):10, Vector2(0, 10):40, Vector2(-10, 0):20, Vector2(10, 0):20}


func _ready():
	connect("jump", find_parent("Player"), "_jump")

func _physics_process(delta):
	ray_enable()
	rotation = vec.angle()
	
	if is_colliding():
		var dect = get_collider()
		if dect.name == "JumpCliff":
			if Input.is_action_just_pressed("Jump") and jumpable == true:
				emit_signal("jump")
				jumpable = false
				yield(get_tree().create_timer(0.7), "timeout")
				jumpable = true

func ray_enable():
	vec = find_parent("Player").vec

	for x in vec_config:
		if vec == x:
			cast_to.x = vec_config[x]
			enabled = true
			return
	
	enabled = false
