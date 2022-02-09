extends CanvasLayer

var world = {
	"0":{
		"res":"res://World/0 - Start/World.tscn",
		"name":"Start Menu"
	},
	
	"1":{
		"res":"res://World/1 - Home/World.tscn",
		"name":"Home"
	},
	
	"2":{
		"res":"res://World/2 - Sola Town/World.tscn",
		"name":"Sola Town"
	},
	
	"3":{
		"res":"res://World/3 - Sola Beach/World.tscn",
		"name":"Sola Beach"
	},
	
	"4":{
		"res":"res://World/4 - Side Forest/World.tscn",
		"name":"Side Forest"
	},
	
	"6":{
		"res":"res://World/6 - Grora/World.tscn",
		"name":"Grora"
	}
	
}

func fade(to_go: int):
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

