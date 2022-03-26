extends KinematicBody2D

onready var player = owner.get_node("Player")
onready var Drop = preload("res://Object/PickableObject/PickableObject.tscn")
var health = 10
var awaken = false
var path = []
var vec = Vector2()

func _attacked(damage):
	if not awaken:
		awaken = true
	
	health -= damage
	if health <= 0:
		var drop = Drop.instance()
		drop.global_position = self.global_position
		owner.add_child(drop)
		queue_free()

func _physics_process(delta):
	if awaken:
		path = owner.get_node("Nav").get_simple_path(global_position, player.global_position, false)
		vec = global_position.direction_to(path[1])
	
	move_and_slide(vec * 90)
