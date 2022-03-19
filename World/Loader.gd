extends CanvasLayer

var world = {
	"0":{
		"res":"res://World/Start/World.tscn",
		"name":"Start Menu"
	},
	
	"1":{
		"res":"res://World/Home/World.tscn",
		"name":"Home"
	},
	
	"2":{
		"res":"res://World/Town/World.tscn",
		"name":"Town"
	},
	
	"3":{
		"res":"res://World/Sola Beach/World.tscn",
		"name":"Sola Beach"
	},
	
	"4":{
		"res":"res://World/Side Forest/World.tscn",
		"name":"Side Forest"
	},
	
	"6":{
		"res":"res://World/Grora - 1/World.tscn",
		"name":"Grora"
	}
	
}

func fade_to(to_go: int):
	$ColorRect.visible = true
	get_tree().paused = false
	$Anim.play("Fade")
	yield($Anim, "animation_finished")
	get_tree().change_scene(world[str(to_go)]["res"])
	Info.stat["place"] = world[str(to_go)]["name"]
	$Anim.play_backwards("Fade")
	yield($Anim, "animation_finished")
	$ColorRect.visible = false
	get_tree().paused = false

func fade(mode: bool):
	if mode == false:
		$ColorRect.visible = true
		get_tree().paused = false
		$Anim.play("Fade")
		yield($Anim, "animation_finished")
	else:
		$Anim.play_backwards("Fade")
		yield($Anim, "animation_finished")
		$ColorRect.visible = false
		get_tree().paused = false
