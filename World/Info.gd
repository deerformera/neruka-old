extends CanvasLayer

var stat = {
	"player":{
		"name":"cat",
		"debug":false,
		"place":"",
		
		"position":{
			"y":0,
			"x":0
		},
		
		"exp":0,
		"health":18,
		"coin":0,
		"inv":[
			[0,0],
			[0,0],
			[0,0],
			[0,0],
			[0,0],
			[0,0],
			[0,0],
			[0,0]
		],
		
		"eq":{
			
			"armor":{
				"equipped":3,
				"inv":[1, 2, 3]
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
		
		"knowledge":[4]
	
	},
	
	"shopstock":{
		"RotShop":[["item",1,1,3], ["item",2,5,3], ["item",3,5,1], ["item",4,5,10], ["item",5,5,1]]
	}
}

var armor = 0
var mousemode = false


func _ready():
	$Version.text = ProjectSettings.get_setting("application/verlist/Version")

func _give_item(id, amount):
	for x in stat["player"]["inv"]:
		if x[0] == id:
			x[1] += amount
			return
			
	for x in stat["player"]["inv"]:
		if x[0] == 0:
			x[0] = id
			x[1] += amount
			return

func _give_eq(type, id):
	if Info.stat["player"]["eq"][type]["inv"].has(id):
		return
	Info.stat["player"]["eq"][type]["inv"].append(id)

func _null_checker():
	for x in stat["player"]["inv"]:
		if x[1] == 0:
			x[0] = 0

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
	stat = to_json(file.get_var())
	file.close()
