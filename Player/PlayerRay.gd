extends RayCast2D

var vec = Vector2()

func _physics_process(delta):

	ray_enable()

	rotation = vec.angle()

#	if is_colliding():
#		get_collider()


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

