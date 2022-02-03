extends CanvasLayer

var stat = {
	"name":"",
	"debug":false,
	"place":"",
	
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
			"inv":[]
		},
		
		"hat":{
			"equipped":0,
			"inv":[]
		}
		
	},
	
	"contact":[],
	
	"shopstock":{
		"RotShop":[
			["item",1,1,3], ["item",2,5,3], ["item",3,5,1], ["item",4,5,10], ["item",5,5, 100]
		]
	}
	
}

var mousemode = false

func _ready():
	$Version.text = ProjectSettings.get_setting("application/verlist/Version")

func _give_item(id, amount):
	for x in stat["inv"]:
		if x[0] == id:
			x[1] += amount
			return
			
	for x in stat["inv"]:
		if x[0] == 0:
			x[0] = id
			x[1] += amount
			return

func _give_eq(type, id):
	if Info.stat["eq"][type]["inv"].has(id):
		return
	Info.stat["eq"][type]["inv"].append(id)


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
	var dir = Directory.new()
	if not dir.dir_exists("user://saves"):
		dir.make_dir("user://saves")
	
	var file = File.new()
	file.open("user://saves/player.tres", File.WRITE)
	file.store_var(stat)
	file.close()

func _load():
	var file = File.new()
	file.open("user://saves/player.tres", File.READ)
	stat = file.get_var()
	file.close()
