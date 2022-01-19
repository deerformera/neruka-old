extends StaticBody2D

var entered = false
var body_name

func _ready():
	$Area2D.connect("body_entered", self, "_entered")
	$Area2D.connect("body_exited", self, "_exited")

func _entered(body):
	entered = true
	body_name = body

func _exited(body):
	entered = false

func _input(event):
	if Input.is_action_just_pressed("Interact") and entered == true:
		_refresh(true)



func _refresh(opened: bool = false):
	if opened:
		$Particles2D.emitting = true
		$Sprite.frame = 1
		$Area2D.queue_free()
		body_name._get_eq("boots", 3)
