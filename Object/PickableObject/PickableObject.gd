extends StaticBody2D

export (int, 1, 2) var id = 1
onready var ObjTex = "res://Object/PickableObject/object.tres"

var tex = {}

func _ready():
	var f = File.new()
	f.open(ObjTex, File.READ)
	tex = parse_json(f.get_as_text())
	$Sprite.texture = load(tex[str(id)]["res"])

func _pop(body):
	$Pop.show()
	if Input.is_action_just_pressed("Interact"):
		Info.carried_object = id
		get_tree().get_nodes_in_group("Player")[0]._refresh_carry()
		

func _unpop():
	$Pop.hide()
