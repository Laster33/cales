extends RigidBody2D

@export var dir = Vector2()
var draggable = false
var dragged = false
var placeVec = Vector2()
@onready var grids = get_node("../Grid_Manager")
var posStart

func _ready():
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	posStart = self.position
	
func _input(event):
	if event.is_action_pressed("leftClick"):
		if(dragged):
			dragged = false
			grids.isCarrying = false
			self.z_index = 0
			global_transform.origin = posStart
			self.modulate.a8 = 255
		else:
			if(draggable):
				if(!grids.isCarrying):
					dragged = true
					self.z_index = 1
					grids.isCarrying = true
					grids.isScaler = true
					grids.scalerVec = dir
					grids.scalerObj = self
					self.modulate.a8 = 124


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(dragged):
		global_transform.origin = (get_global_mouse_position())

func _on_mouse_entered():
	draggable = true

func _on_mouse_exited():
	draggable = false
