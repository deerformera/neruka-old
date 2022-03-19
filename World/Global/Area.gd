extends Area2D

func _ready():
	connect("body_entered", self, "_damaged")

func _damaged(body):
	if body.name == "Player":
		body._damaged(2, -body.vec)
