extends Position2D


onready var slash = preload("res://Items/Node/C1 - Slash.tscn")
onready var ice = preload("res://Items/Node/Ice.tscn")

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
	s.position.x = 20
	add_child(s)
	s.play()
	yield(s, "animation_finished")
	remove_child(s)
	find_parent("Player").jump = false
	$Area/Coll.disabled = true
	attacking = false

func _attacking(body):
	body._attacked(get_parent().damage)
	body.add_child(ice.instance())
