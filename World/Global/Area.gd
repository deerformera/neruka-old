extends Area2D

func _ready():
	connect("body_entered", self, "_damaged")

func _damaged(body):
	Info.stat["health"] -= 20
