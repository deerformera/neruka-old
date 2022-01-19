extends CanvasLayer

func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	$VideoPlayer.play()
	yield($VideoPlayer, "finished")
	yield(get_tree().create_timer(0.5), "timeout")
	Loader.fade(0)
