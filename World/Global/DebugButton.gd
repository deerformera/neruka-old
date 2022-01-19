extends CanvasLayer

func _ready():
	$btn.connect("toggled", self, "_debug")

func _debug(bol):
	if bol == true:
		get_tree().paused = true
		$Popup.show()
		$Popup/Panel/VB/NameText.text = Info.stat["name"]
		$Popup/Panel/VB/HealthText.value = Info.stat["health"]
		$Popup/Panel/VB/InventoryText.text = str(Info.stat["inv"])
		$Popup/Panel/VB/EqClawText.text = str(Info.stat["eq"]["claw"]["inv"])
		$Popup/Panel/VB/EqBootsText.text = str(Info.stat["eq"]["boots"]["inv"])
	else:
		Info.stat["name"] = $Popup/Panel/VB/NameText.text
		Info.stat["health"] = $Popup/Panel/VB/HealthText.value
		Info.stat["inv"] = str2var($Popup/Panel/VB/InventoryText.text)
		Info.stat["eq"]["claw"]["inv"] = str2var($Popup/Panel/VB/EqClawText.text)
		Info.stat["eq"]["boots"]["inv"] = str2var($Popup/Panel/VB/EqBootsText.text)
		get_tree().paused = false
		$Popup.hide()
