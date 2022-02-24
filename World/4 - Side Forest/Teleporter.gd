extends Area2D

func _ready():
	connect("body_entered", self, "_teleport")

func _teleport(body):
	Loader.fade(6)
