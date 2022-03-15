extends Node2D

var cooldown = false

func _ready():
	$Timer.connect("timeout", self, "_cooldown")

func _input(event):
	if Input.is_action_just_pressed("Shield") and not cooldown:
		find_parent("Player")._heal(2)
		cooldown = true
		$Timer.start(10)

func _cooldown():
	cooldown = false

