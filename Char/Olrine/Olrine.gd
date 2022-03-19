extends KinematicBody2D

export (int) var health = 10
onready var animstate = $AnimTree.get("parameters/playback")

var combat = false
var attack = false
var in_area = false
var vec = Vector2()
var player: KinematicBody2D
var path = []

func _attacked(damage):
	health -= damage
	animstate.travel("Damaged")
	$AttackTimer.stop()
	$AttackArea/Sprite.hide()
	yield(get_tree().create_timer(0.3), "timeout")
	attack = false
	if health <= 0:
		for x in get_children():
			if x.get_class() != "Particles2D":
				x.queue_free()
		
		vec = Vector2()
		$Particles2D.emitting = true
		yield(get_tree().create_timer(3), "timeout")
		queue_free()
		
	animstate.travel("Normal")

func _physics_process(delta):
	if combat:
		path = owner.get_node("Nav").get_simple_path(global_position, (player.global_position), false)
		$Ray.cast_to = player.global_position - global_position
		if attack:
			vec = Vector2()
		else:
			vec = global_position.direction_to(path[1])
			if $Ray.cast_to.length() <= 30:
				attack = true
				animstate.travel("Attack")
				$AttackArea.look_at(player.global_position)
				$AttackArea/Sprite.show()
				$AttackTimer.start()
	else:
		vec = Vector2()
		
	move_and_slide(vec * 100)

func _on_body_entered(body):
	player = body
	combat = true
	$Ray.enabled = true
	$Area/Coll.shape.radius = 128

func _on_body_exited(body):
	player = null
	combat = false
	$Ray.enabled = false
	$Area/Coll.shape.radius = 64



func _on_AttackArea_body_entered(body):
	in_area = true

func _on_AttackArea_body_exited(body):
	in_area = false


func _on_AttackTimer_timeout():
	if in_area:
		player._damaged(5, Vector2())
	
	$AttackArea/Sprite.hide()
	attack = false
