extends Position2D

var attack = false

func _ready():
	visible = false
	$Area2D/CollisionShape2D.disabled = true
	$Area2D.connect("body_entered", self, "_attacking")

func _physics_process(delta):
	rotation = get_parent().animtree.get("parameters/Idle/blend_position").angle()
	if Input.is_action_just_pressed("Attack") and attack == false:
		_attack()

func _attack():
	attack = true
	get_parent().vec = Vector2()
	get_parent().jump = true
	$Area2D/CollisionShape2D.disabled = false
	visible = true
	$AnimatedSprite.play()
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.stop()
	visible = false
	$Area2D/CollisionShape2D.disabled = true
	get_parent().jump = false
	attack = false

func _attacking(body):
	body._attacked(5)
