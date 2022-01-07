extends TileMap

func _interacted():
	get_tree().change_scene("res://World/World.tscn")
