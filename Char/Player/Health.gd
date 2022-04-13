extends Control

onready var h_full = preload("res://UI/Hearth-full.png")
onready var h_empty = preload("res://UI/Hearth-empty.png")
onready var h_half = preload("res://UI/Hearth-half.png")
onready var s_full = preload("res://UI/Shield-full.png")
onready var s_half = preload("res://UI/Shield-half.png")
onready var s_empty = preload("res://UI/Shield-empty.png")
onready var health = Info.dat["player"]["health"]
onready var armor = Info.armor

var max_armor = 0 setget _armor_changed
var max_health = 18

func _ready():
	_regen_count()

func _armor_changed(value):
	max_armor = value
	_regen_count()
	_checker("s")

func _heal(value):
	Info.dat["player"]["health"] += value
	_checker("h")

func _damaged(damage):
	if armor > 0:
		armor -= damage
		if armor < 0:
			health += armor
			armor = 0
	else:
		health -= damage
	
	if health <= 0:
		print("dead")
	
	Info.dat["player"]["health"] = health
	Info.armor = armor
	
	find_parent("Player").get_node("ShieldPartic").emitting = false
	
	_refresh()
	_regen_count()

func _regen_count():
	for x in get_children():
		if x.get_class() == "Timer":
			x.queue_free()
			remove_child(x)
	
	var t = Timer.new()
	t.wait_time = 2
	t.autostart = true
	t.one_shot = true
	t.connect("timeout", self, "_regen_start")
	add_child(t)

func _regen_start():
	for x in get_children():
		if x.get_class() == "Timer":
			x.queue_free()
			remove_child(x)
	
	var t = Timer.new()
	t.wait_time = 1
	t.autostart = true
	t.connect("timeout", self, "_regen")
	add_child(t)
	
	find_parent("Player").get_node("ShieldPartic").emitting = true

func _regen():
	Info.armor += 1
	_checker("s")

func _checker(type):
	if type == "s":
		armor = Info.armor
		if armor >= max_armor:
			find_parent("Player").get_node("ShieldPartic").emitting = false
			armor = max_armor
			for x in get_children():
				if x.get_class() == "Timer":
					x.queue_free()
					remove_child(x)
	
	elif type == "h":
		health = Info.dat["player"]["health"]
		if health >= max_health:
			health = max_health
	
	_refresh()

func _refresh():
	for x in $HealthBar.get_child_count():
		if health > x * 2 + 1:
			$HealthBar.get_node(str(x)).texture = h_full
		elif health > x * 2:
			$HealthBar.get_node(str(x)).texture = h_half
		else:
			$HealthBar.get_node(str(x)).texture = h_empty
	
	for x in $ShieldBar.get_child_count():
		if max_armor <= x * 2:
			$ShieldBar.get_node(str(x)).hide()
		else:
			$ShieldBar.get_node(str(x)).show()
			$ShieldBar.get_node(str(x)).texture = s_empty
		
		if armor > x * 2 + 1:
			$ShieldBar.get_node(str(x)).texture = s_full
		elif armor > x * 2:
			$ShieldBar.get_node(str(x)).texture = s_half

