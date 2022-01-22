extends MarginContainer

signal dead

func _ready():
	$HealthBar.value = Info.stat["health"]
	$HealthBorder.value = Info.stat["health"]

func _physics_process(delta):
	$HealthBar.value = Info.stat["health"]
	if $HealthBorder.value > $HealthBar.value:
		$HealthBorder.value -= 1
	elif $HealthBorder.value < $HealthBar.value:
		$HealthBorder.value += 1
	if Info.stat["health"] <= 0:
		emit_signal("dead")
