extends Node
@onready var tile = load("res://prefabs/panel.tscn")
@onready var border = load("res://prefabs/border.tscn")
var manager
var isCarrying = false
var isScaler = false
var scalerVec
var scalerObj
var gridCount

func _ready():
	manager = get_node("/root/main")
	countGrid()
	
func _process(delta):
	pass
	
func countGrid():
	gridCount = self.get_child_count() - 1
	
func _input(event):
	if event.is_action_pressed("leftClick"):
		await get_tree().create_timer(0.2).timeout
		countGrid()
		if(gridCount <= 0):
			manager.setComp()
			
