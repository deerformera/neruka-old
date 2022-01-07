extends CanvasLayer

var path = "user://setting.tres"
var setting = {
	"master":0,
	"music":0,
	"sfx":0
}

func _ready():
	_load()
	_set_data()
	_tweented()

func _save():
	var f = File.new()
	f.open(path, File.WRITE)
	f.store_string(to_json(setting))
	f.close()

func _load():
	var f = File.new()
	if !f.file_exists(path):
		return
	f.open(path, File.READ)
	setting = parse_json(f.get_as_text())
	f.close()

func _set_data():
	$M2/BG/M/VB/TabSplit/RightSplit/MasterSlider.value = setting["master"]
	$M2/BG/M/VB/TabSplit/RightSplit/MusicSlider.value = setting["music"]
	$M2/BG/M/VB/TabSplit/RightSplit/SFXSlider.value = setting["sfx"]
	$M2/BG/M/VB/TabSplit/RightSplit/MasterLabel.text = "Master Volume : " + str($M2/BG/M/VB/TabSplit/RightSplit/MasterSlider.value) + "%"
	$M2/BG/M/VB/TabSplit/RightSplit/MusicLabel.text = "Music Volume : " + str($M2/BG/M/VB/TabSplit/RightSplit/MusicSlider.value) + "%"
	$M2/BG/M/VB/TabSplit/RightSplit/SFXLabel.text = "SFX Volume : " + str($M2/BG/M/VB/TabSplit/RightSplit/SFXSlider.value) + "%"


func _tweented():
	$M2.visible = false
	$M1.anchor_left = 0.25
	$M1.anchor_right = 0.75
	$M2.anchor_bottom = 0.5
	$M2/BG/M/VB/Title/SettingLabel.percent_visible = 0
	
	var t = Tween.new()
	add_child(t)
	t.interpolate_property($M1, "anchor_left", null, 0, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.interpolate_property($M1, "anchor_right", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()
	yield(t, "tween_completed")
	$M2.visible = true
	t.interpolate_property($M2, "anchor_bottom", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.interpolate_property($M2/BG/M/VB/Title/SettingLabel, "percent_visible", null, 1, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	t.start()


func _on_ThemeButton_item_selected(index):
	if index == 0:
		$"/root/World/Player/Menu/2nd/1".normal = load("res://Controls/Menu/Menu (B)/Menu_UnSelected1.png")
		$"/root/World/Player/Menu/2nd/2".normal = load("res://Controls/Menu/Menu (B)/Menu_UnSelected2.png")
		$"/root/World/Player/Menu/2nd/3".normal = load("res://Controls/Menu/Menu (B)/Menu_UnSelected3.png")
		$"/root/World/Player/Menu/2nd/4".normal = load("res://Controls/Menu/Menu (B)/Menu_UnSelected4.png")
		$"/root/World/Player/Menu/2nd/6".normal = load("res://Controls/Menu/Menu (B)/Menu_UnSelected6.png")
		$"/root/World/Player/Menu/2nd/7".normal = load("res://Controls/Menu/Menu (B)/Menu_UnSelected7.png")
		$"/root/World/Player/Menu/2nd/8".normal = load("res://Controls/Menu/Menu (B)/Menu_UnSelected8.png")
		$"/root/World/Player/Menu/2nd/9".normal = load("res://Controls/Menu/Menu (B)/Menu_UnSelected9.png")

		$"/root/World/Player/Menu/2nd/1".pressed = load("res://Controls/Menu/Menu (B)/Menu_Selected1.png")
		$"/root/World/Player/Menu/2nd/2".pressed = load("res://Controls/Menu/Menu (B)/Menu_Selected2.png")
		$"/root/World/Player/Menu/2nd/3".pressed = load("res://Controls/Menu/Menu (B)/Menu_Selected3.png")
		$"/root/World/Player/Menu/2nd/4".pressed = load("res://Controls/Menu/Menu (B)/Menu_Selected4.png")
		$"/root/World/Player/Menu/2nd/6".pressed = load("res://Controls/Menu/Menu (B)/Menu_Selected6.png")
		$"/root/World/Player/Menu/2nd/7".pressed = load("res://Controls/Menu/Menu (B)/Menu_Selected7.png")
		$"/root/World/Player/Menu/2nd/8".pressed = load("res://Controls/Menu/Menu (B)/Menu_Selected8.png")
		$"/root/World/Player/Menu/2nd/9".pressed = load("res://Controls/Menu/Menu (B)/Menu_Selected9.png")
	
	elif index == 1:
		$"/root/World/Player/Menu/2nd/1".normal = load("res://Controls/Menu/Menu (G)/Menu_UnSelected1.png")
		$"/root/World/Player/Menu/2nd/2".normal = load("res://Controls/Menu/Menu (G)/Menu_UnSelected2.png")
		$"/root/World/Player/Menu/2nd/3".normal = load("res://Controls/Menu/Menu (G)/Menu_UnSelected3.png")
		$"/root/World/Player/Menu/2nd/4".normal = load("res://Controls/Menu/Menu (G)/Menu_UnSelected4.png")
		$"/root/World/Player/Menu/2nd/6".normal = load("res://Controls/Menu/Menu (G)/Menu_UnSelected6.png")
		$"/root/World/Player/Menu/2nd/7".normal = load("res://Controls/Menu/Menu (G)/Menu_UnSelected7.png")
		$"/root/World/Player/Menu/2nd/8".normal = load("res://Controls/Menu/Menu (G)/Menu_UnSelected8.png")
		$"/root/World/Player/Menu/2nd/9".normal = load("res://Controls/Menu/Menu (G)/Menu_UnSelected9.png")

		$"/root/World/Player/Menu/2nd/1".pressed = load("res://Controls/Menu/Menu (G)/Menu_Selected1.png")
		$"/root/World/Player/Menu/2nd/2".pressed = load("res://Controls/Menu/Menu (G)/Menu_Selected2.png")
		$"/root/World/Player/Menu/2nd/3".pressed = load("res://Controls/Menu/Menu (G)/Menu_Selected3.png")
		$"/root/World/Player/Menu/2nd/4".pressed = load("res://Controls/Menu/Menu (G)/Menu_Selected4.png")
		$"/root/World/Player/Menu/2nd/6".pressed = load("res://Controls/Menu/Menu (G)/Menu_Selected6.png")
		$"/root/World/Player/Menu/2nd/7".pressed = load("res://Controls/Menu/Menu (G)/Menu_Selected7.png")
		$"/root/World/Player/Menu/2nd/8".pressed = load("res://Controls/Menu/Menu (G)/Menu_Selected8.png")
		$"/root/World/Player/Menu/2nd/9".pressed = load("res://Controls/Menu/Menu (G)/Menu_Selected9.png")

func _on_VSyncButton_toggled(button_pressed):
	OS.vsync_enabled = button_pressed


func _on_MasterSlider_value_changed(value):
	setting["master"] = value
	$M2/BG/M/VB/TabSplit/RightSplit/MasterLabel.text = "Master Volume : " + str(value) + "%"

func _on_SFXSlider_value_changed(value):
	setting["sfx"] = value
	$M2/BG/M/VB/TabSplit/RightSplit/SFXLabel.text = "SFX Volume : " + str(value) + "%"

func _on_MusicSlider_value_changed(value):
	setting["music"] = value
	$M2/BG/M/VB/TabSplit/RightSplit/MusicLabel.text = "Music Volume : " + str(value) + "%"


func _on_CloseButton_pressed():
	_save()
	get_tree().paused = false
	queue_free()


