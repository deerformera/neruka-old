extends CanvasLayer

var path = "user://Saves/player.tres"

var a

onready var t = $Tween

func _ready():
	$Grad.region_rect.size = get_viewport().size
	$M1.visible = false
	$M2.visible = false
	$M2/BG/P1/VB/VB/PlayButton.disabled = true
	$M2/BG/P1/VB/VB/ExitButton.disabled = true
	$M2/BG/P1/VB/Title.percent_visible = 0
	$M1.anchor_left = 0.25
	$M1.anchor_right = 0.75
	$M2.anchor_bottom = 0.5
	yield(get_tree().create_timer(0.5),"timeout")
	$M1.visible = true
	_tweented()

func _physics_process(delta):
	$Grad.region_rect.position.x += 10

func _tweented():
	t.interpolate_property($M1, "anchor_left", null, 0, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.interpolate_property($M1, "anchor_right", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()
	yield(t, "tween_completed")
	$M2.visible = true
	t.interpolate_property($M2, "anchor_bottom", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.interpolate_property($M2/BG/P1/VB/Title, "percent_visible", null, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	t.start()
	yield(t, "tween_all_completed")
	$M2/BG/P1/VB/VB/PlayButton.disabled = false
	$M2/BG/P1/VB/VB/ExitButton.disabled = false
	

func _tween_tab(Pb, Pa):
	t.interpolate_property($M2, "anchor_bottom", 1, 0.5, 0.4, Tween.TRANS_BACK, Tween.EASE_OUT)
	t.start()
	Pb.visible = false
	yield(t, "tween_completed")
	t.interpolate_property($M2, "anchor_bottom", 0.5, 1, 0.25, Tween.TRANS_BACK, Tween.EASE_OUT)
	t.start()
	Pa.visible = true

func _on_CloseButton_pressed():
	_tween_tab($M2/BG/P2, $M2/BG/P1)

func _on_PlayButton_pressed():
	_tween_tab($M2/BG/P1, $M2/BG/P2)

func _on_ExitButton_pressed():
	get_tree().quit()


func _on_NewButton_pressed():
	var f = File.new()
	if f.file_exists(path):
		_tween_tab($M2/BG/P2, $M2/BG/P3)
		return

	Loader.fade(1)


func _on_LoadButton_pressed():
	Loader.fade(6)

func _on_YesButton_pressed():
	Loader.fade(1)


func _on_NoButton_pressed():
	_tween_tab($M2/BG/P3, $M2/BG/P2)

