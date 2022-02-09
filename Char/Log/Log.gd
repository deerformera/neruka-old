extends CanvasLayer

onready var B1 = $M2/BG/M/VB/Desc/Button/B1
onready var B2 = $M2/BG/M/VB/Desc/Button/B2
onready var Name = $M2/BG/M/VB/Title/Name
onready var richtextlabel = $M2/BG/M/VB/Desc/RichTextLabel
var ended = false
var speaker
var conv = "000"
var Log = "res://Char/Log/log.tres"
var text = {}

func _ready():
	var f = File.new()
	f.open(Log, File.READ)
	text = parse_json(f.get_as_text())
	f.close()
	
	B1.connect("pressed", self, "_B1_pressed")
	B2.connect("pressed", self, "_B2_pressed")
	$M2/BG/M/VB/Title/NextButton.connect("pressed", self, "_next_conv")
	$M2/BG/M/VB/Title/CloseButton.connect("pressed", self, "_Close")


func _B1_pressed():
	var firstkey = text[speaker.name][conv]["answer"].keys()[0]
	conv = text[speaker.name][conv]["answer"][firstkey]
	_refresh()

func _B2_pressed():
	var firstkey = text[speaker.name][conv]["answer"].keys()[1]
	conv = text[speaker.name][conv]["answer"][firstkey]
	_refresh()

func _Close():
	speaker._conversation_ended()
	queue_free()

func _next_conv():
	if text[speaker.name][conv]["type"] == "text":
		conv = text[speaker.name][conv]["next"]
	
	elif text[speaker.name][conv]["type"] == "last" and ended:
		if Info.stat["player"]["contact"].empty():
			Info.stat["player"]["contact"].append_array([[speaker.name, text[speaker.name][conv]["next"]]])
		else:
			for x in Info.stat["player"]["contact"]:
				if x[0] == speaker.name:
					x[1] = text[speaker.name][conv]["next"]
		
		speaker._conversation_ended()
		queue_free()
	
	_refresh()

func _identification(Speaker):
	speaker = Speaker
	
	Name.text = speaker.name
	
	if not Info.stat["player"]["contact"].empty():
		for x in Info.stat["player"]["contact"]:
			if x[0] == speaker.name:
				conv = x[1]
	
	_tweented()
	_refresh()

func _refresh():
	richtextlabel.text = text[speaker.name][conv]["text"].format({"NAME":Info.stat["player"]["name"]})
	
	if text[speaker.name][conv]["type"] == "question":
		$M2/BG/M/VB/Desc/Button.show()
		$M2/BG/M/VB/Title/NextButton.hide()
		
		B1.text = "        >  " + text[speaker.name][conv]["answer"].keys()[0]
		B2.text = "        >  " + text[speaker.name][conv]["answer"].keys()[1]
		
	elif text[speaker.name][conv]["type"] == "text":
		$M2/BG/M/VB/Desc/Button.hide()
		$M2/BG/M/VB/Title/NextButton.show()
	
	elif text[speaker.name][conv]["type"] == "trade":
		$M2/BG/M/VB/Desc/Button.hide()
		$M2/BG/M/VB/Title/NextButton.hide()
		
		var taken = text[speaker.name][conv]["taken"]
		var given = text[speaker.name][conv]["given"]
		var next = text[speaker.name][conv]["next"]
		
		var tradeable = false
		
		if taken["type"] == "item":
			for x in Info.stat["player"]["inv"]:
				if x[0] == taken["value"][0] and x[1] - taken["value"][1] >= 0:
					x[1] -= taken["value"][1]
					tradeable = true
					conv = next[0]
					_refresh()
			
			if !tradeable:
				conv = next[1]
				_refresh()
		
		elif taken["type"] == "eq":
			if Info.stat["player"]["eq"][taken["value"][0]]["inv"].has(taken["value"][1]):
				tradeable = true
				conv = next[0]
				_refresh()
			else:
				conv = next[1]
				_refresh()
		
		if given["type"] == "item" and tradeable:
			Info._give_item(taken["value"][0], taken["value"][1])
			
		elif given["type"] == "eq" and tradeable:
			Info._give_eq(given["value"][0], given["value"][1])
	
	elif text[speaker.name][conv]["type"] == "last":
		$M2/BG/M/VB/Desc/Button.hide()
		$M2/BG/M/VB/Title/NextButton.show()
		
		if text[speaker.name][conv]["text"] == "":
			if Info.stat["player"]["contact"].empty():
				Info.stat["player"]["contact"].append_array([[speaker.name, text[speaker.name][conv]["next"]]])
			else:
				for x in Info.stat["player"]["contact"]:
					if x[0] == speaker.name:
						x[1] = text[speaker.name][conv]["next"]
			
			speaker._conversation_ended()
			queue_free()
		else:
			yield(get_tree().create_timer(0.1), "timeout")
			ended = true
	
	elif text[speaker.name][conv]["type"] == "knowledge":
		$M2/BG/M/VB/Desc/Button.hide()
		$M2/BG/M/VB/Title/NextButton.hide()
		
		if text[speaker.name][conv].has("taken"):
			print("bayar :((")
		else:
			speaker.player._partic()
			Info.stat["player"]["knowledge"].append(int(text[speaker.name][conv]["given"]))
			
		
		conv = text[speaker.name][conv]["next"]
		_refresh()


func _tweented():
	$M1.visible = true
	$M2.visible = false
	$M1.anchor_left = 0.25
	$M1.anchor_right = 0.75
	$M2.anchor_bottom = 0.5
	
	var t = Tween.new()
	add_child(t)
	t.interpolate_property($M1, "anchor_left", null, 0, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.interpolate_property($M1, "anchor_right", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()
	yield(t, "tween_completed")
	$M2.visible = true
	t.interpolate_property($M2, "anchor_bottom", null, 1, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	t.start()
