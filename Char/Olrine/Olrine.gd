extends KinematicBody2D

export (int) var health = 10
onready var animstate = $AnimTree.get("parameters/playback")
var already_dead = false

func _attacked(damage):
	animstate.travel("Damaged")
	health -= damage
	if health <= 0 and not already_dead:
		already_dead = true
		yield(get_tree().create_timer(0.4), "timeout")
		for x in get_children():
			if x.get_class() != "Particles2D":
				x.queue_free()
		
		get_node("Particles2D").emitting = true
		
		yield(get_tree().create_timer(3), "timeout")
		queue_free()
