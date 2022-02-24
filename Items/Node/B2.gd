extends Area2D

var dashing = false
var dashable = true
var vec: Vector2
var rot

func _ready():
	connect("body_entered", self, "_entered")
	connect("body_exited", self, "_exited")

func _physics_process(delta):
	rotation = find_parent("Player").get_node("AnimTree").get("parameters/Walk/blend_position").angle()
	
	if Input.is_action_just_pressed("Attack") and dashable and dashing == false:
		vec = find_parent("Player").vec
		dashing = true
	
	if dashing:
		find_parent("Player").vec = lerp(Vector2(), vec * 8, 1)
		find_parent("Player").get_node("Camera2D").position = Vector2()
		yield(get_tree().create_timer(0.05), "timeout")
		find_parent("Player").vec = Vector2()
		dashing = false

func _entered(body):
	dashable = false
func _exited(body):
	dashable = true
