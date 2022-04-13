extends StaticBody2D

export(StreamTexture) var Writed

var entered = false
var writed = false


func _pop(player):
	$Popup.show()

func _unpop():
	$Popup.hide()

func _on_interacted():
	$Canv/P.show()
	get_tree().paused = true

func _on_Line_text_entered(new_text):
	if new_text == "":
		return
	if new_text == "test":
		Info.dat["player"]["debug"] = true
		
		if get_tree().root.get_node("DebugButton") == null:
			var dbgbtn = load("res://World/Global/DebugButton.tscn")
			get_tree().root.add_child(dbgbtn.instance())
	
	Info.dat["player"]["name"] = new_text
	
	$Sprite.texture = Writed
	writed = true
	
	$Canv/P.hide()
	get_tree().paused = false
