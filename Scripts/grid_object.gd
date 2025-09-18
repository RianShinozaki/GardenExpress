class_name GridObject
extends Node2D

@export var snapToGrid: bool
@export var canBePickedUp: bool
var pickedUp: bool

@onready var area: Area2D = $Area2D

var cellSize: int
var originPoint: Vector2i
var radius: int

func _ready() -> void:
	cellSize = grid_controller.instance.cellSize
	originPoint = grid_controller.instance.originPoint
	area.input_event.connect(_on_input_event)
	
func _process(_delta: float):
	var gridCoordinate = Vector2i( roundf((global_position.x - originPoint.x) / float(cellSize)), roundf((global_position.y - originPoint.y) / float(cellSize)))
	
	if snapToGrid:
		global_position = originPoint + Vector2i(cellSize * gridCoordinate.x, cellSize * gridCoordinate.y)
	
	print(roundf(global_position.x / float(cellSize)))
	print(gridCoordinate)
	
	if pickedUp:
		global_position = get_viewport().get_mouse_position() - Vector2(cellSize/2, cellSize/2)
		if Input.is_action_just_released('mouse_click'):
			pickedUp = false
			snapToGrid = true

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if Input.is_action_just_pressed('mouse_click') and canBePickedUp:
		print("clicked")
		pickedUp = true
		snapToGrid = false
