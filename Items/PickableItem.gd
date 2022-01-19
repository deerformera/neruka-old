extends KinematicBody2D

var ItemTexture = "res://Items/ItemTexture.tres"
var tex = {}

var vec = Vector2()
var body = null
var picked = false

export var id = 1
export var amount = 1

func _ready():
	var f = File.new()
	f.open(ItemTexture, File.READ)
	tex = parse_json(f.get_as_text())
	f.close()
	
	$Sprite.texture = load(tex[str(id)])

func _picked_by(who):
	body = who
	picked = true

func _physics_process(delta):
	
	if picked:
		vec = body.global_position - global_position
		if vec.length() <= 10:
			body.get_item(id, amount)
			queue_free()
	
	move_and_slide(vec * 6)
