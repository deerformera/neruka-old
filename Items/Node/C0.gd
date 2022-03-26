extends Node2D

onready var slash = preload("res://Items/Node/C0 - Slash.tscn")
var attacking = false

func _ready():
	$Area.connect("body_entered", self, "_attacking")
	$Area/Coll.disabled = true

func _physics_process(delta):
	rotation = find_parent("Player").get_node("AnimTree").get("parameters/Walk/blend_position").angle()
	if Input.is_action_just_pressed("Interact") and attacking == false and not find_parent("Player").interacting:
		_attack()

func _attack():
	attacking = true
	$Area/Coll.disabled = false
	find_parent("Player").animstate.travel("Attack")
	find_parent("Player").vec = Vector2()
	find_parent("Player").jump = true
	var s = slash.instance()
	s.position = Vector2(20, 0)
	s.playing = true
	add_child(s)
	yield(s, "animation_finished")
	find_parent("Player").jump = false
	s.queue_free()
	$Area/Coll.disabled = true
	attacking = false

func _attacking(body):
	find_parent("Player")._set_hit(body)
	body._attacked(get_parent().damage)
