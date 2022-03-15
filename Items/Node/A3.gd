extends Node2D

var cooldown = false

func _ready():
	$Timer.connect("timeout", self, "_cooldown")

func _input(event):
	if Input.is_action_just_pressed("Shield") and not cooldown:
		find_parent("Player")._dead()
		cooldown = true
		yield(get_tree().create_timer(2), "timeout")
		find_parent("Player")._undead()
		$Timer.start(4)

func _cooldown():
	cooldown = false

