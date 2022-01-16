extends Area2D

signal get_item

export (int) var id
export (int) var amount

func _ready():
	if amount == 0:
		queue_free()

func _on_Item_body_entered(body):
	connect("get_item", body, "_get_a_thing")
	emit_signal("get_item", id, amount)
	queue_free()
