#extends Node
extends RigidBody2D

var draggable = false
var dragged = false
var cubeTotal = 0
var cubeNow = 0
var placable = false
var placeVec = Vector2()
var placed = false
var tilesNow = []
@onready var grids = get_node("../Grid_Manager")
@export var colorSelect:colorPalette
@onready var cube = load("res://prefabs/cube.tscn")
@onready var pick = load("res://audio/pick.wav")
var color
var posStart

enum colorPalette{
	Red,
	Yellow,
	Green,
	Blue,
	Purple,
	Pink
}

const Red = Color('fc123e')
const Yellow = Color('fddc23')
const Green = Color('21f0a9')
const Blue = Color('1bd1f8')
const Purple = Color('750ed5')
const Pink = Color('d042f8')

func _ready():
	posStart = self.position
	whichColor()
	colorize()
	grids.body_shape_entered.connect(_on_grid_manager_body_shape_entered)
	grids.body_shape_exited.connect(_on_grid_manager_body_shape_exited)
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	countCubes()
	
func _input(event):
	if event.is_action_pressed("leftClick"):
		if(dragged):
			if(placable):
				dragged = false
				draggable = false
				global_transform.origin = placeVec
				placed = true
				self.z_index = 0
				color.a8 = 255
				colorize()
				delete_Tiles(tilesNow)
				grids.isCarrying = false
			else:
				dragged = false
				draggable = false
				global_transform.origin = posStart
				self.z_index = 1
				color.a8 = 255
				colorize()
				grids.isCarrying = false
		else:
			if(draggable):
				if(!placed):
					if(!grids.isCarrying):
						dragged = true
						color.a8 = 124
						colorize()
						grids.isCarrying = true
						self.z_index = 1
				else:
					if(grids.isScaler):
						scaling(grids.scalerVec)
		
func _physics_process(delta):
	if(dragged):
		global_transform.origin = (get_global_mouse_position())
			
func _on_mouse_entered():
	draggable = true

func _on_mouse_exited():
	draggable = false

func colorize():
	for i in self.get_children():
		i.get_child(1).modulate = color

func countCubes():
	cubeTotal = 0
	for i in self.get_children():
		cubeTotal += 1

func scaling(dirVec: Vector2):
	for i in self.get_children():
		var now = i.get_child(0)
		now.target_position = dirVec
		now.force_raycast_update()
		if(!now.is_colliding()):
			var nowCube = cube.instantiate()
			nowCube.position = i.position + dirVec
			add_child(nowCube)
	grids.scalerObj.queue_free()
	colorize()
	grids.isCarrying = false
	grids.isScaler = false
	grids.scalerVec = Vector2(0, 0)
	await get_tree().create_timer(0.1).timeout
	delete_Tiles(tilesNow)
	countCubes()
	
			
func _on_grid_manager_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	tilesNow.append(local_shape_index) 
	if(body.name == self.name):
		cubeNow += 1
		if(cubeNow == cubeTotal):
			placable = true
			placeVec = grids.get_child(local_shape_index).global_position

func _on_grid_manager_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	tilesNow.erase(local_shape_index)
	if(body.name == self.name):
		cubeNow -= 1
		if(cubeNow != cubeTotal):
			placable = false

func delete_Tiles(arr: Array):
	for i in arr:
		grids.get_child(i).queue_free()

func whichColor():
	match colorSelect:
		colorPalette.Red:
			color = Red
		colorPalette.Yellow:
			color = Yellow
		colorPalette.Green: 
			color = Green
		colorPalette.Blue:
			color = Blue
		colorPalette.Purple:
			color = Purple
		colorPalette.Pink:
			color = Pink
