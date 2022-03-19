extends Area2D

var vec: Vector2

func _ready():
	connect("body_entered", self, "_heal")

func _heal(body):
	if body.name == "Player":
		body._heal(1)
