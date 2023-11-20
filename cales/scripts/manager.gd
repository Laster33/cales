extends Node

@onready var control = self.get_child(0)
@export var levelCount = 0
@onready var sucSound = load("res://audio/success.wav")
@onready var clickSound = load("res://audio/pick.wav")
var compText
var level = 1
var compLevels = []
var nowLevel

func _ready():
	compText = control.get_child(4)
	compLevels.resize(levelCount + 1)
	compLevels.fill(false)
	setScene()

func setScene():
	control.get_child(0).text = str(level)
	if(nowLevel != null):
		nowLevel.queue_free()
	nowLevel = load("res://scences/"+ str(level) +".tscn").instantiate()
	add_child(nowLevel)

func _on_next_button_down():
	changeLevel(1)

func _on_back_button_down():
	changeLevel(-1)

func _on_restart_button_down():
	setScene()
	control.get_child(5).stream = clickSound
	control.get_child(5).play()

func setComp():
	compLevels[level] = true
	compText.visible = true
	control.get_child(1).modulate = Color('b4f7ad')
	control.get_child(5).stream = sucSound
	control.get_child(5).play()

func changeLevel(x: int):
	level = level + x
	level = clamp(level, 1, levelCount) 
	if(compLevels[level]):
		compText.visible = true
	else:
		compText.visible = false
	setScene()
	control.get_child(1).modulate = Color('ffffff')
	control.get_child(5).stream = clickSound
	control.get_child(5).play()
	

