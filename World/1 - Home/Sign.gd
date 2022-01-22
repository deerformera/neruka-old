extends StaticBody2D

export(StreamTexture) var Writed

var entered = false
var writed = false

func _ready():
	$Popup.hide()

func _pop(player):
	$Popup.show()
	
	if Input.is_action_just_pressed("Interact"):
		$Canv/P.show()
		get_tree().paused = true

func _unpop():
	$Popup.hide()


func _on_Line_text_entered(new_text):
	if new_text == "":
		return
	if new_text == "test":
		Info.stat["debug"] = true
		
		if get_tree().root.get_node("DebugButton") == null:
			var dbgbtn = load("res://World/Global/DebugButton.tscn")
			get_tree().root.add_child(dbgbtn.instance())
	
	Info.stat["name"] = new_text
	
	$Sprite.texture = Writed
	writed = true
	
	$Canv/P.hide()
	get_tree().paused = false
