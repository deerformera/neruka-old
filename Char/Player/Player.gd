extends KinematicBody2D

onready var partic = preload("res://Char/Player/Learn.tscn")
onready var animtree = $AnimTree
onready var animstate = $AnimTree.get("parameters/playback")
var openmenu
var jump = false
var hurt = false
var interacting = false
var speed
var vec = Vector2()
var pos = Vector2()


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
		animtree.set("parameters/Attack/blend_position", vec)
		animtree.set("parameters/MoveToIdle/blend_position", vec)
		animtree.set("parameters/Walk/blend_position", vec)
		animstate.travel("Walk")
		move_and_slide(vec * speed)
	
	if hurt:
		animstate.travel("Hurt")

func move():
	vec = Vector2()
	
	vec.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	vec.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	vec = vec * 10

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
	
	var zom = $Camera2D.zoom
	var t = Tween.new()
	add_child(t)
	t.interpolate_property($Camera2D, "zoom", null, zom * 1.1, 0.4, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	t.start()
	yield(get_tree().create_timer(0.7), "timeout")
	t.interpolate_property($Camera2D, "zoom", null, zom, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(7, true)
	speed = 10
	jump = false

func _heal(value):
	$HealPartic.emitting = true
	$HUD/C/Health._heal(value)

func _damaged(damage, knockback_direction):
	animtree.set("parameters/Hurt/blend_position", vec)
	$HUD/C/Health._damaged(damage)
	hurt = true
	jump = true
	vec = knockback_direction
	yield(get_tree().create_timer(0.2), "timeout")
	vec = Vector2()
	yield(get_tree().create_timer(0.2), "timeout")
	jump = false
	hurt = false

func _dead():
	modulate.a = 0.4
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(3, false)
	set_collision_mask_bit(7, false)

func _undead():
	modulate.a = 1
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(3, true)
	set_collision_mask_bit(7, true)

func _partic():
	var particle = partic.instance()
	particle.global_position = global_position
	particle.emitting = true
	get_tree().root.add_child(particle)
