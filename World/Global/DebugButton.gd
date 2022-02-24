extends CanvasLayer

func _ready():
	$btn.connect("toggled", self, "_debug")

func _debug(bol):
	if bol == true:
		get_tree().paused = true
		$Popup.show()
		$Popup/Panel/VB/NameText.text = Info.stat["player"]["name"]
		$Popup/Panel/VB/HealthText.value = Info.stat["player"]["health"]
		$Popup/Panel/VB/InventoryText.text = str(Info.stat["player"]["inv"])
		$Popup/Panel/VB/EqClawText.text = str(Info.stat["player"]["eq"]["claw"]["inv"])
		$Popup/Panel/VB/EqBootsText.text = str(Info.stat["player"]["eq"]["boots"]["inv"])
	else:
		Info.stat["player"]["name"] = $Popup/Panel/VB/NameText.text
		Info.stat["player"]["health"] = $Popup/Panel/VB/HealthText.value
		Info.stat["player"]["inv"] = str2var($Popup/Panel/VB/InventoryText.text)
		Info.stat["player"]["eq"]["claw"]["inv"] = str2var($Popup/Panel/VB/EqClawText.text)
		Info.stat["player"]["eq"]["boots"]["inv"] = str2var($Popup/Panel/VB/EqBootsText.text)
		get_tree().paused = false
		$Popup.hide()
