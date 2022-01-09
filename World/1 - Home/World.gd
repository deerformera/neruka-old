extends YSort

func _ready():
	Info.stat["scene"] = 0
	get_node("Player/Camera2D").editor_draw_limits = true
	get_node("Player/Camera2D").limit_left = -208
	get_node("Player/Camera2D").limit_right = 272
	get_node("Player/Camera2D").limit_top = -320
	get_node("Player/Camera2D").limit_bottom = 320
