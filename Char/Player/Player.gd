extends KinematicBody2D

onready var animtree = $AnimTree
onready var animstate = $AnimTree.get("parameters/playback")
onready var PickableObject = preload("res://Object/PickableObject/PickableObject.tscn")
onready var HitAnim = preload("res://Char/Player/HitAnim.tscn")
onready var health = Info.dat["player"]["health"]
var speed
var vec = Vector2()
var tex = {}

enum mstate {
	walk,
	jump,
	attack,
	hurt,
}

enum istate {
	normal,
	interact,
	carry
}

var cistate = istate.normal
var cmstate = mstate.walk

func _ready():
	var f = File.new()
	f.open("res://Object/PickableObject/object.tres", File.READ)
	tex = parse_json(f.get_as_text())
	f.close()
	
	_refresh_carry()

func _input(event):
	if Input.is_action_just_pressed("Interact"):
		if cistate == istate.carry and not $Ray.entered:
			_uncarry(animtree.get("parameters/Walk/blend_position") * 2)
			Info._scan_object()

func _physics_process(delta):
	match cmstate:
		mstate.walk:
			_move_state(delta)
		mstate.jump:
			_jump_state()
		mstate.attack:
			_attack_state()
		mstate.hurt:
			_hurt_state() 

func _move_state(delta):
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

func _jump_state():
	move_and_slide(vec * 16)


func _jump():
	cmstate = mstate.jump
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
	cmstate = mstate.walk

func _attack_state():
	move_and_slide(Vector2())

func _hurt_state():
	animstate.travel("Hurt")
	move_and_slide(vec * 10)

func _set_hit(enemy):
	var hitanim = HitAnim.instance()
	hitanim.play()
	hitanim.global_position = enemy.global_position - (enemy.global_position - global_position)/2
	owner.add_child(hitanim)
	$Camera2D.smoothing_enabled = false
	yield(hitanim, "animation_finished")
	$Camera2D.smoothing_enabled = true
	hitanim.queue_free()

func _damaged(damage, knockback_direction):
	if cistate == istate.carry:
		_uncarry(knockback_direction * 4)
	cmstate = mstate.hurt
	$HUD/C/Health._damaged(damage)
	vec = knockback_direction
	yield(get_tree().create_timer(0.2), "timeout")
	vec = Vector2()
	yield(get_tree().create_timer(0.2), "timeout")
	cmstate = mstate.walk

func _heal(value):
	$HUD/C/Health._heal(value)
	$HealPartic.emitting = true

func _learn():
	var partic = load("res://Char/Player/Learn.tscn").instance()
	partic.emitting = true
	partic.global_position = self.global_position
	owner.add_child(partic)

func _refresh_carry():
	var id = Info.carried_object
	
	if id == 0:
		if get_node("Object") != null:
			get_node("Object").queue_free()
			
			var t = Timer.new()
			t.wait_time = 0.02
			t.autostart = true
			t.one_shot = true
			t.connect("timeout", self, "_set_carry", [false])
			add_child(t)
		
	else:
		if get_node("Object") == null:
			var sprite = Sprite.new()
			sprite.texture = load(tex[str(id)]["res"])
			sprite.name = "Object"
			add_child(sprite)
			
			var t = Timer.new()
			t.wait_time = 0.02
			t.autostart = true
			t.one_shot = true
			t.connect("timeout", self, "_set_carry", [true])
			add_child(t)

func _uncarry(drop_position):
	var object = PickableObject.instance()
	object.global_position = global_position + drop_position
	object.id = Info.carried_object
	owner.add_child(object)
	Info.carried_object = 0
	_refresh_carry()

func _set_carry(bol):
	if bol == true:
		cistate = istate.carry
	else:
		cistate = istate.normal
