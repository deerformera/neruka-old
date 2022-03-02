extends Area2D

var vec: Vector2

func _ready():
	connect("body_entered", self, "_damaged")

func _damaged(body):
	vec = -body.vec
	if body.name == "Player":
		body.hurt = true
		body.jump = true
		body.vec = lerp(body.vec, vec, 1)
		body._damaged(2)
		yield(get_tree().create_timer(0.2), "timeout")
		body.vec = Vector2()
		yield(get_tree().create_timer(0.2), "timeout")
		body.jump = false
