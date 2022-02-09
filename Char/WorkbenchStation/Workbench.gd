extends StaticBody2D

onready var workbench = preload("res://Char/WorkbenchStation/WorkbenchStation.tscn")
var study = false

func _pop(body):
	$PopUp.show()
	if Input.is_action_just_pressed("Interact") and study == false:
		study = true
		get_tree().root.add_child(workbench.instance())
		get_tree().root.get_node("WorkbenchStation")._identification(self)
		get_tree().paused = true

func _conversation_ended():
	get_tree().paused = false
	study = false

func _unpop():
	$PopUp.hide()
