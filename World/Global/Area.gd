extends Area2D

signal spike

func _on_Area_body_entered(body):
	connect("spike", body, "_spiked")
	emit_signal("spike")
