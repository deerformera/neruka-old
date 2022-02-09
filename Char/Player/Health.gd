extends MarginContainer

signal dead

var changed = false

func _ready():
	$HealthBar.value = Info.stat["player"]["health"]


func _physics_process(delta):
	if $HealthBar.value > Info.stat["player"]["health"]:
		changed = true
	
	if changed:
		var t = Tween.new()
		add_child(t)
		t.interpolate_property($HealthBar, "value", null, Info.stat["health"], 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
		t.start()
		
		var sprite = $"../../../Sprite"
		
		if $HealthBar.value <= 1:
			connect("dead", $"../../..", "_dead")
			emit_signal("dead")
			t.interpolate_property(sprite, "modulate:a", null, 0.5, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
			t.start()
