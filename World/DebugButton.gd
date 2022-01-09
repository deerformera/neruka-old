extends CanvasLayer

func _ready():
	$btn.connect("toggled", self, "_debug")
	print(Info.stat)

func _debug(bol):
	if bol == true:
		$Popup.show()
		$Popup/Panel/VB/NameText.text = Info.stat["name"]
		$Popup/Panel/VB/HealthText.text = str(Info.stat["health"])
		$Popup/Panel/VB/InventoryText.text = str(Info.stat["inv"])
		$Popup/Panel/VB/EquipmentText.text = str(Info.stat["eq"])
	else:
		Info.stat["name"] = str($Popup/Panel/VB/NameText.text)
		Info.stat["health"] = int($Popup/Panel/VB/HealthText.text)
		Info.stat["inv"] = str2var($Popup/Panel/VB/InventoryText.text)
		Info.stat["eq"] = str2var($Popup/Panel/VB/EquipmentText.text)
		print(Info.stat)
		$Popup.hide()
