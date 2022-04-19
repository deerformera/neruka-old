extends KinematicBody2D

onready var nav: Navigation2D = owner.get_node("Nav")
onready var animstate = $AnimTree.get("parameters/playback")
onready var Drop = preload("res://Object/PickableObject/PickableObject.tscn")
var entered = false
var attack_entered = false
var health = 10
var vec = Vector2()
var tovec = Vector2()
var player: KinematicBody2D
var path = []

enum mstate {
	idle,
	combat,
	attack,
	hurt
}

var cstate = mstate.idle

func _ready():
	$AttackTimer.connect("timeout", self, "_on_attack")
	$Area.connect("body_entered", self, "_on_area_entered")
	$Area.connect("body_exited", self, "_on_area_exited")
	$AttackArea.connect("body_entered", self, "_on_attack_area_entered")
	$AttackArea.connect("body_exited", self, "_on_attack_area_exited")

func _physics_process(delta):
	match cstate:
		mstate.idle:
			vec = Vector2()
#			print("idle")
		mstate.combat:
			_combat_state(delta)
#			print("combat")
		mstate.attack:
			_attack_state(delta)
#			print("attack")
		mstate.hurt:
			pass

func _combat_state(delta):
	animstate.travel("Attack")
	path = nav.get_simple_path(global_position, player.global_position, true)
	vec = global_position.direction_to(path[1])
	move_and_slide(vec * 100)
	tovec = player.global_position - global_position
	$Ray.cast_to = tovec
	if tovec.length() <= 30:
		cstate = mstate.attack

func _attack_state(delta):
	vec = Vector2()
	if $AttackTimer.is_stopped():
		$AttackTimer.start()
		$AttackArea/Sprite.show()
		$AttackArea.look_at(player.global_position)
		animstate.travel("Attack")

func _damaged(damage):
	health -= damage
	cstate = mstate.hurt
	animstate.travel("Damaged")
	$AttackTimer.stop()
	$AttackArea/Sprite.hide()
	yield(get_tree().create_timer(0.3), "timeout")
	animstate.travel("Normal")
	if health <= 0:
		var drop = Drop.instance()
		drop.global_position = self.global_position
		owner.add_child(drop)
		Info._scan_object()
		for x in get_children():
			if not x.get_class() == "Particles2D":
				x.queue_free()
			else:
				x.emitting = true
				yield(get_tree().create_timer(3), "timeout")
				queue_free()
				return
		
	cstate = mstate.combat

func _on_area_entered(body):
	cstate = mstate.combat
	player = body
	entered = true

func _on_area_exited(body):
	cstate = mstate.idle
	entered = false

func _on_attack_area_entered(body):
	attack_entered = true

func _on_attack_area_exited(body):
	attack_entered = false

func _on_attack():
	if entered:
		cstate = mstate.combat
	else:
		cstate = mstate.idle
	
	if attack_entered:
		player._damaged(5, Vector2())
	
	$AttackArea/Sprite.hide()

