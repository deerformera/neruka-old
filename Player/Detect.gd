extends Area2D

signal picked
var pickable = false
var body

func _ready():
	connect("body_entered", self, "_Detect_body")
	connect("body_exited", self, "_UnDetect_body")

func _Detect_body(body_name):
	body = body_name
	pickable = true

func _UnDetect_body(body_name):
	body = null
	pickable = false

func _input(event):
	if Input.is_action_just_pressed("Interact") and pickable:
		body._picked_by(get_parent())
		pickable = false
