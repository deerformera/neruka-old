extends StaticBody2D

export (int) var health
onready var item_scene = preload("res://Items/PickableItem/PickableItem.tscn")
onready var BleedingPartic = preload("res://Object/Tree/TreeBleedingPartic.tscn")
var already_dead = false

func _damaged(damage):
	
	health -= damage
	
	$BleedingPartic.restart()
	
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

