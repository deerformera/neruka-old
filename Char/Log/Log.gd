extends CanvasLayer

onready var B1 = $M2/BG/M/VB/Desc/Button/B1
onready var B2 = $M2/BG/M/VB/Desc/Button/B2
onready var Name = $M2/BG/M/VB/Title/Name
onready var richtextlabel = $M2/BG/M/VB/Desc/RichTextLabel

var speaker
var player
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
		if conv == "null":
			speaker._conversation_ended()
			queue_free()
			return
	
	_refresh()

func _identification(Speaker, Player):
	speaker = Speaker
	player = Player
	
	Name.text = speaker.name
	
	if Info.stat["contact"].size() != 0:
		for x in Info.stat["contact"]:
			if x[0] == speaker.name:
				conv[0] = str(x[1])
	
	_tweented()
	_refresh()

func _refresh():
	richtextlabel.text = text[speaker.name][conv]["text"].format({"NAME":Info.stat["name"]})
	
	if text[speaker.name][conv]["type"] == "question":
		$M2/BG/M/VB/Desc/Button.show()
		$M2/BG/M/VB/Title/NextButton.hide()
		
		B1.text = " > " + text[speaker.name][conv]["answer"].keys()[0]
		B2.text = " > " + text[speaker.name][conv]["answer"].keys()[1]
		
	elif text[speaker.name][conv]["type"] == "text":
		$M2/BG/M/VB/Desc/Button.hide()
		$M2/BG/M/VB/Title/NextButton.show()
	
	elif text[speaker.name][conv]["type"] == "trade":
		$M2/BG/M/VB/Desc/Button.hide()
		$M2/BG/M/VB/Title/NextButton.hide()
		
		var type = ["taken", "given"]
		
		for typ in type:
			if text[speaker.name][conv][typ]["type"] == "eq":
				var eq_type = text[speaker.name][conv][typ]["value"][0]
				var eq_id = text[speaker.name][conv][typ]["value"][1]
				
				if typ == "given":
					player._give_eq(eq_type, eq_id)
				else:
					# Add Command for Sync
					player._take_eq(eq_type, eq_id)
			
			elif text[speaker.name][conv][typ]["type"] == "item":
				var item_id = text[speaker.name][conv][typ]["value"][0]
				var item_amount = text[speaker.name][conv][typ]["value"][1]
				
				if typ == "given":
					player._give_item(item_id, item_amount)
				else:
					for x in Info.stat["inv"]:
						if x[0] == item_id and x[1] - item_amount >= 0:
							player._take_item(item_id, item_amount)
							return
						else:
							print("no Money!!")
					

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

