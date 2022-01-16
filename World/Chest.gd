extends StaticBody2D

var entered = false
var bdy

func _ready():
	$Area2D.connect("body_entered", self, "_entered")
	$Area2D.connect("body_exited", self, "_exited")

func _entered(body):
	if body.name == "Player":
		entered = true
		bdy = body

func _exited(body):
	if body.name == "Player":
		entered = false

func _input(event):
	if Input.is_action_just_pressed("Interact") and entered == true:
		_refresh(true)
		bdy._emit_partic()



func _refresh(bol: bool = false):
	if bol == true:
		$CPUParticles2D.emitting = true
		$Sprite.frame = 1
		$Area2D.queue_free()
	else:
		$Sprite.frame = 0
