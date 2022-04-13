extends Node2D

var entered = false
var object
var vec = Vector2()

func _ready():
	$Area2D.connect("body_entered", self, "_entered")
	$Area2D.connect("body_exited", self, "_exited")

func _entered(body):
	entered = true
	if get_parent().cistate == get_parent().istate.normal:
		body._pop(get_parent())
		get_parent().cistate = get_parent().istate.interact
	object = body

func _exited(body):
	entered = false
	if get_parent().cistate == get_parent().istate.interact:
		body._unpop()
		get_parent().cistate = get_parent().istate.normal

func _physics_process(delta):
	rotation = get_parent().animtree.get("parameters/Idle/blend_position").angle()

func _input(event):
	if event.is_action_pressed("Interact") and get_parent().cistate == get_parent().istate.interact:
		object._on_interacted()
