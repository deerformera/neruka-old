extends StaticBody2D

var health = 15
var attacked = false

onready var item_scene = preload("res://Items/PickableItem/PickableItem.tscn")

func _attacked(damage):
	if attacked == false:
		attacked = true
		health -= damage
		if health <= 0:
			var item = item_scene.instance()
			item.id = 2
			item.amount = 3
			find_parent("World").add_child(item)
			
			queue_free()
		attacked = false
