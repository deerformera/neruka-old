extends StaticBody2D

export (int, 1, 2) var id = 1
onready var ObjTex = "res://Object/PickableObject/object.tres"

var tex = {}
var picked = false
var player

func _ready():
	var f = File.new()
	f.open(ObjTex, File.READ)
	tex = parse_json(f.get_as_text())
	$Sprite.texture = load(tex[str(id)]["res"])
	f.close()

func _pop(body):
	$Pop.show()
	player = body

func _unpop():
	$Pop.hide()

func _on_interacted():
	Info.carried_object = id
	player._refresh_carry()
	queue_free()
	remove_from_group("Object")
	Info._scan_object()
