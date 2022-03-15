extends Position2D

onready var slash = preload("res://Items/Node/C4 - Slash.tscn")
onready var player = find_parent("Player")

var attacking = false
var launch = false

func _physics_process(delta):
	rotation = player.get_node("AnimTree").get("parameters/Walk/blend_position").angle()
	
	if Input.is_action_just_pressed("Interact") and attacking == false:
		_attack()

func _attack():
	attacking = true
	player.vec = Vector2()
	player.jump = true
	player.animstate.travel("Attack")
	var slash_anim = slash.instance()
	slash_anim.get_node("AnimSprite").play()
	slash_anim.get_node("AnimSprite").frame = 0
	slash_anim.global_position = self.global_position
	slash_anim.rotation = rotation
	slash_anim.direction = (player.get_node("AnimTree").get("parameters/Walk/blend_position") / 2)
	find_parent("World").add_child(slash_anim)
	yield(slash_anim.get_node("AnimSprite"), "animation_finished")
	player.jump = false
	attacking = false
