extends CanvasLayer

var path = "user://Saves/player.tres"
var dir = "user://Saves"
var dbgbtn = preload("res://World/DebugButton.tscn")

var stat = {
	"name":"",
	"debug":false,
	"scene":"",
	
	"position":{
		"y":0,
		"x":0
	},
	
	"exp":0,
	"health":100,
	"coin":0,
	"inv":[
		[1,1],
		[0,0],
		[2,1],
		[0,0],
		[1,1],
		[0,0],
		[0,0],
		[0,0]
		],
	
	"eq":{
		"armor":{
			"equipped":0,
			"inv":[]
		},
		
		"boots":{
			"equipped":0,
			"inv":[]
		},
		
		"claw":{
			"equipped":0,
			"inv":[1, 2, 3]
		},
		
		"hat":{
			"equipped":0,
			"inv":[1, 2]
		}
	}
}

var mousemode = false

func _ready():
	$M/VersionInfo.text = ProjectSettings.get_setting("application/config/Version")
	var d = Directory.new()
	if !d.dir_exists(dir):
		d.make_dir(dir)

func _debug():
	get_tree().root.add_child(dbgbtn.instance())
	get_tree().root.get_node("DebugButton").connect("toggled", self, "_debugging")
	print(get_tree().root.get_node("DebugButton"))

func _debugging(bol):
	print(bol)

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if mousemode == true:
			mousemode = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			mousemode = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if Input.is_action_just_pressed("F11"):
		OS.window_fullscreen = !OS.window_fullscreen

func _save():
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_var(stat)
	file.close()

func _load():
	var file = File.new()
	file.open(path, File.READ)
	stat = file.get_var()
	file.close()
