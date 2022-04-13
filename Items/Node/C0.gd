extends Node2D

onready var slash = preload("res://Items/Node/C0 - Slash.tscn")
onready var player = find_parent("Player")
var attacking = false

func _ready():
	$Area.connect("body_entered", self, "_attacking")
	$Area/Coll.disabled = true

func _physics_process(delta):
	rotation = player.get_node("AnimTree").get("parameters/Walk/blend_position").angle()
	if Input.is_action_just_pressed("Interact"):
		if attacking == false and player.cistate == player.istate.normal:
			_attack()

func _attack():
	attacking = true
	$Area/Coll.disabled = false
	player.cmstate = find_parent("Player").mstate.attack
	player.animstate.travel("Attack")
	var s = slash.instance()
	s.position = Vector2(20, 0)
	s.playing = true
	add_child(s)
	yield(s, "animation_finished")
	player.cmstate = find_parent("Player").mstate.walk
	s.queue_free()
	$Area/Coll.disabled = true
	attacking = false

func _attacking(body):
	player._set_hit(body)
	body._damaged(get_parent().damage)
