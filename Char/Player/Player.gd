extends KinematicBody2D

onready var animtree = $AnimTree
onready var animstate = $AnimTree.get("parameters/playback")
onready var AA = get_node("AA")
var openmenu
var jump = false
var speed = 0
var vec = Vector2()
var pos = Vector2()

func _ready():
	speed = 10

func _physics_process(delta):

	pos = $HUD/C/Joystick.pos

	if !jump:
		move()
		touch_move()
	
	if vec == Vector2():
		animstate.travel("Idle")

	else:
		$Camera2D.position = vec * 2
		animtree.set("parameters/Idle/blend_position", vec)
		animtree.set("parameters/Jump/blend_position", vec)
		animtree.set("parameters/IdleToMove/blend_position", vec)
		animtree.set("parameters/Walk/blend_position", vec)
		animtree.set("parameters/Hurt/blend_position", vec)
		animstate.travel("Walk")
		move_and_slide(vec * speed)


func move():
	vec = Vector2()
	if Input.is_action_pressed("Down"):
		vec.y = 10
	if Input.is_action_pressed("Up"):
		vec.y = -10
	if Input.is_action_pressed("Left"):
		vec.x = -10
	if Input.is_action_pressed("Right"):
		vec.x = 10

func touch_move():
	if pos.x > 0.5:
		vec.x = 10
	if pos.x < -0.5:
		vec.x = -10
	if pos.y > 0.5:
		vec.y = 10
	if pos.y < -0.5:
		vec.y = -10

func _jump():
	animstate.travel("Jump")
	speed = 16
	jump = true
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(7, false)
	
	yield(get_tree().create_timer(0.7), "timeout")
	
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(7, true)
	speed = 10
	jump = false

func _dead():
	print("dead")
	set_collision_mask_bit(0, false)
