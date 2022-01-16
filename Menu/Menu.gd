extends GridContainer

var mospos = Vector2()
var campos = [
	Vector2(-20, -20),
	Vector2(0, -20),
	Vector2(20, -20),
	Vector2(-20, 0),
	Vector2(0, 0),
	Vector2(20, 0),
	Vector2(-20, 20),
	Vector2(0, 20),
	Vector2(20, 20)
]

var menu = [
	"res://Menu/Settings/Setting.tscn",
	"res://Menu/Stat/Stat.tscn",
	"res://Menu/Exit/Exit.tscn",
	"res://Menu/Equipment/Equipment.tscn",
	"",
	"res://Menu/Inventory/Inventory.tscn",
	"",
	"",
	""
]


var selected = null
var selecting = false

func _ready():
	$"5/TSB".connect("pressed", self, "_pressed")
	$"5/TSB".connect("released", self, "_released")
	_hide(false)

func _physics_process(delta):
	if selecting:
		get_parent().get_node("Camera2D").position = campos[(selected - 1)]

func _pressed():
	selected = 5
	selecting = true
	_hide(true)

func _released():
	selecting = false
	_hide(false)
	_instance()

	for x in get_children():
		if x.pressed == true:
			return
	
	for y in get_children():
		if y.pressed == false:
			selected = 5


func _hide(a):
	for x in get_children():
		for y in x.get_children():
			y.visible = a
	
	$"5/TSB".visible = true

func _instance():
	yield(get_tree().create_timer(0.02), "timeout")
	
	if selected in [5, 7, 8, 9]:
		return
	
	var l = load(menu[selected - 1])
	get_parent().add_child(l.instance())
	get_tree().paused = true
