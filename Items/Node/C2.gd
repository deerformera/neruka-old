extends Node2D

onready var slash = preload("res://Items/Node/C2 - Slash.tscn")
onready var fire = preload("res://Items/Node/Fire.tscn")

var burned = false
var attacking = false

func _ready():
	$Area.connect("body_entered", self, "_attacking")

func _physics_process(delta):
	rotation = find_parent("Player").get_node("AnimTree").get("parameters/Walk/blend_position").angle()
	
	if Input.is_action_just_pressed("Attack") and attacking == false:
		_attack()

func _attack():
	attacking = true
	$Area/Coll.disabled = false
	find_parent("Player").animstate.travel("Attack")
	find_parent("Player").vec = Vector2()
	find_parent("Player").jump = true
	var s = slash.instance()
	s.frame = 0
	s.position = Vector2(20, 0)
	add_child(s)
	s.play()
	yield(s, "animation_finished")
	remove_child(s)
	find_parent("Player").jump = false
	$Area/Coll.disabled = true
	attacking = false

func _attacking(body):
	body._attacked(get_parent().damage)
	for x in body.get_children():
		if x.name == "Fire":
			x.queue_free()
			remove_child(x)
	
	body.add_child(fire.instance())
