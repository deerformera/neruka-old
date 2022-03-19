extends Area2D

func _ready():
	connect("body_entered", self, "_change")

func _change(body):
	Loader.fade_to(4)
