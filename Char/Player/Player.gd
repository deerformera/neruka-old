extends KinematicBody2D

onready var animstate = $AnimTree.get("parameters/playback")
onready var HitAnim = preload("res://Char/Player/HitAnim.tscn")
onready var animtree = $AnimTree
onready var health = Info.stat["player"]["health"]

var interacting = false
var speed
var vec = Vector2()

enum mstate {
	walk,
	jump,
	attack,
	hurt
}

var cstate = mstate.walk

func _physics_process(delta):
	match cstate:
		mstate.walk:
			_move_state(delta)
		mstate.jump:
			_jump_state(delta)
		mstate.attack:
			_attack_state(delta)
		mstate.hurt:
			_hurt_state(delta)

func _move_state(delta):
	vec = Vector2()
	
	vec.x = (Input.get_action_strength("Right") - Input.get_action_strength("Left")) * 10
	vec.y = (Input.get_action_strength("Down") - Input.get_action_strength("Up")) * 10
	
	if vec != Vector2():
		$Camera2D.position = vec * 2
		animtree.set("parameters/Idle/blend_position", vec)
		animtree.set("parameters/Jump/blend_position", vec)
		animtree.set("parameters/Attack/blend_position", vec)
		animtree.set("parameters/MoveToIdle/blend_position", vec)
		animtree.set("parameters/Walk/blend_position", vec)
		animtree.set("parameters/Hurt/blend_position", vec)
		
		animstate.travel("Walk")
	else:
		animstate.travel("Idle")
	
	move_and_slide(vec * speed)

func _jump_state(delta):
	move_and_slide(vec * 16)

func _jump():
	cstate = mstate.jump
	animstate.travel("Jump")
	var zoom = Vector2(0.3, 0.3)
	var t = Tween.new()
	add_child(t)
	t.interpolate_property($Camera2D, "zoom", null, zoom*1.1, 0.4, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(7, false)
	yield(get_tree().create_timer(0.7),"timeout")
	t.interpolate_property($Camera2D, "zoom", null, zoom, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(7, true)
	cstate = mstate.walk

func _attack_state(delta):
	move_and_slide(Vector2())

func _set_hit(enemy):
	var hitanim = HitAnim.instance()
	hitanim.play()
	hitanim.global_position = enemy.global_position - (enemy.global_position - global_position)/2
	owner.add_child(hitanim)
	$Camera2D.smoothing_enabled = false
	yield(hitanim, "animation_finished")
	$Camera2D.smoothing_enabled = true
	hitanim.queue_free()

func _hurt_state(delta):
	animstate.travel("Hurt")
	move_and_slide(vec * 10)

func _damaged(damage, knockback_direction):
	cstate = mstate.hurt
	$HUD/C/Health._damaged(damage)
	vec = knockback_direction
	yield(get_tree().create_timer(0.2), "timeout")
	vec = Vector2()
	yield(get_tree().create_timer(0.2), "timeout")
	cstate = mstate.walk

func _heal(value):
	$HUD/C/Health._heal(value)
	$HealPartic.emitting = true
