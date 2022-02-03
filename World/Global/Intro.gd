extends CanvasLayer

func _ready():
	$VideoPlayer.play()
	yield($VideoPlayer, "finished")
	Loader.fade(0)
