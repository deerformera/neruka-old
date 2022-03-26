extends Area2D

export (int) var to_go

func _ready():
	connect("body_entered", self, "_teleport")

func _teleport(body):
	Loader.fade_to(to_go)
