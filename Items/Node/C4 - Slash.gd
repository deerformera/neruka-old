extends Position2D

var direction = Vector2()

func _ready():
	$Area.connect("body_entered", self, "_attacking")

func _physics_process(delta):
	position += direction
	yield(get_tree().create_timer(0.2), "timeout")
	$AnimSprite.animation = "backward"
	yield($AnimSprite, "animation_finished")
	queue_free()

func _attacking(body):
	body._attacked(get_parent().get_node("Player/EqManager").damage)
