extends Node2D

var entered = false
var currently_entered = false
var object
var vec = Vector2()

func _ready():
	$Area2D.connect("body_entered", self, "_entered")
	$Area2D.connect("body_exited", self, "_exited")

func _entered(body):
	if entered == true:
		return
	
	entered = true
	object = body

func _exited(body):
	entered = false

func _physics_process(delta):
	rotation = get_parent().animtree.get("parameters/Idle/blend_position").angle()
	
	if entered:
		object._pop(get_parent())
		currently_entered = true
	
	elif !entered and currently_entered:
		object._unpop()
