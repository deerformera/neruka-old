extends StaticBody2D

export (int) var health
onready var item_scene = preload("res://Items/PickableItem/PickableItem.tscn")
var already_dead = false

func _attacked(damage):
	
	health -= damage
	
	
	if health >= 6:
		$BleedingPartic.speed_scale = 1
	elif health >= 4:
		$BleedingPartic.speed_scale = 1.2
	elif health >= 2:
		$BleedingPartic.speed_scale = 1.5
	
	if health <= 0 and already_dead == false:
		already_dead = true
		
		get_node("BleedingPartic").queue_free()
		
		for x in get_children():
			if x.get_class() != "Particles2D":
				x.queue_free()
		
		get_node("DestroyedPartic").emitting = true
		
		var item = item_scene.instance()
		item.id = 2
		item.amount = 3
		item.global_position = global_position
		find_parent("World").add_child(item)
		yield(get_tree().create_timer(3), "timeout")
		queue_free()

