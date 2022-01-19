extends KinematicBody2D

onready var animtree = $AnimTree
onready var animstate = $AnimTree.get("parameters/playback")
onready var AA = get_node("AA")
var openmenu
var moving = false
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
	
	moving = false
	


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
	jump = true
	set_collision_mask_bit(0, false)
	yield(get_tree().create_timer(0.6), "timeout")
	set_collision_mask_bit(0, true)
	jump = false


func _on_Joystick_moving():
	moving = true

func _spiked():
	Info.stat["health"] -= 10


func _on_Health_dead():
	var t = Tween.new()
	add_child(t)
	t.interpolate_property(self, "modulate:a", null, 0.5, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()
	collision_layer = 0
	collision_mask = 0

func _get_item(id, amount):
	for x in Info.stat["inv"]:
		if x[0] == id:
			x[1] += amount
			return
	
	for x in Info.stat["inv"]:
		if x[0] == 0:
			x[0] = id
			x[1] += amount
			return

func _get_eq(type, id):
	if Info.stat["eq"][type]["inv"].has(id):
		return
	Info.stat["eq"][type]["inv"].append(id)
