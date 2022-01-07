extends KinematicBody2D

var speed = 10
var health = 100

onready var animstate = $AnimationTree.get("parameters/playback")
onready var anim = $AnimationTree
onready var vec = Vector2()
onready var player = get_parent().get_node("Player")

func _ready():
	pass

func _physics_process(delta):
	
	anim.set("parameters/Walk/blend_position", vec)
	

	vec = Vector2()
	
	if Input.is_action_pressed("ui_down"):
		vec.y += 10
	elif Input.is_action_pressed("ui_up"):
		vec.y -= 10
	if Input.is_action_pressed("ui_left"):
		vec.x -= 10
	elif Input.is_action_pressed("ui_right"):
		vec.x += 10
	
	move_and_slide(vec * speed)
	
	if vec == Vector2():
		animstate.travel("Idle")
	else:
		animstate.travel("Walk")
		anim.set("parameters/Walk/blend_position", vec)
		anim.set("parameters/Idle/blend_position", vec)

	
	if health <= 0:
		queue_free()



func _on_BodyArea_body_entered(body):
	if body.name == "AA":
		health -= player.dmg
