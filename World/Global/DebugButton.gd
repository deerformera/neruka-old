extends CanvasLayer

func _ready():
	$btn.connect("toggled", self, "_debug")

func _debug(bol):
	if bol == true:
		get_tree().paused = true
		$Popup.show()
		$Popup/Panel/VB/NameText.text = Info.dat["player"]["name"]
		$Popup/Panel/VB/HealthText.value = Info.dat["player"]["health"]
		$Popup/Panel/VB/InventoryText.text = str(Info.dat["player"]["inv"])
		$Popup/Panel/VB/EqClawText.text = str(Info.dat["player"]["eq"]["claw"]["inv"])
		$Popup/Panel/VB/EqBootsText.text = str(Info.dat["player"]["eq"]["boots"]["inv"])
	else:
		Info.dat["player"]["name"] = $Popup/Panel/VB/NameText.text
		Info.dat["player"]["health"] = $Popup/Panel/VB/HealthText.value
		Info.dat["player"]["inv"] = str2var($Popup/Panel/VB/InventoryText.text)
		Info.dat["player"]["eq"]["claw"]["inv"] = str2var($Popup/Panel/VB/EqClawText.text)
		Info.dat["player"]["eq"]["boots"]["inv"] = str2var($Popup/Panel/VB/EqBootsText.text)
		get_tree().paused = false
		$Popup.hide()
