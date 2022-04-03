extends KinematicBody2D

onready var animstate = $AnimTree.get("parameters/playback")
onready var animtree = $AnimTree

var speed
var vec = Vector2()

enum state {
	WALK,
	JUMP,
	HURT
}

var cstate = state.WALK

func _physics_process(delta):
	match cstate:
		state.WALK:
			_move_state(delta)
		state.JUMP:
			print("B")
		state.HURT:
			print("C")

func _move_state(delta):
	vec = Vector2()
	
	vec.x = (Input.get_action_strength("Right") - Input.get_action_strength("Left")) * 10
	vec.y = (Input.get_action_strength("Down") - Input.get_action_strength("Up")) * 10
	
	if vec != Vector2():
		$Camera2D.position = vec * 2
		animtree.set("parameters/Idle/blend_position", vec)
		animtree.set("parameters/Jump/blend_position", vec)
		animtree.set("parameters/Attack/blend_position", vec)
		animtree.set("parameters/MoveToIdle/blend_position", vec)
		animtree.set("parameters/Walk/blend_position", vec)
		
		animstate.travel("Walk")
	else:
		animstate.travel("Idle")
	
	move_and_slide(vec * speed)
