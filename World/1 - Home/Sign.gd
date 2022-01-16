extends StaticBody2D

export(StreamTexture) var Writed

var entered = false
var writed = false

func _ready():
	$Popup.hide()

func _on_Area_body_entered(body):
	$Popup.show()
	entered = true

func _on_Area_body_exited(body):
	$Popup.hide()
	entered = false

func _input(event):

	if Input.is_action_just_pressed("Interact") and entered == true:
		$CanvasLayer/P.show()
		get_tree().paused = true


func _on_Line_text_entered(new_text):
	if new_text == "":
		return
	if new_text == "4dmin":
		Info.stat["debug"] = true
		Info._debug()
	
	Info.stat["name"] = new_text
	
	$Sprite.texture = Writed
	writed = true
	
	$CanvasLayer/P.hide()
	get_tree().paused = false
