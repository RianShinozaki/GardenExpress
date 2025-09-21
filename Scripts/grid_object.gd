class_name GridObject extends Node2D

@export var snap_to_grid: bool = true
@export var can_be_picked_up: bool = true

#I've no idea why I have to do this but yeah
var grid_snap_offset: Vector2 = Vector2(-0.25,-0.25)

var picked_up: bool
var position_before_picked_up: Vector2

@onready var area: Area2D = $Area2D

var cell_size: int
var origin_point: Vector2i
var radius: int

var entered_bodies: Array[Area2D]

func _ready() -> void:
	cell_size = GridController.instance.cell_size
	origin_point = GridController.instance.origin_point
	area.input_event.connect(_on_input_event)
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)
	
func _process(_delta: float):
	
	modulate = Color.WHITE
	
	if snap_to_grid:
		snap_to_grid_now()
	
	if picked_up:
		@warning_ignore("integer_division")
		global_position = get_viewport().get_mouse_position() + Vector2(cell_size/2, cell_size/2)
		if not entered_bodies.is_empty():
			modulate = Color.FIREBRICK
			
		if Input.is_action_just_released('mouse_click'):
			if not entered_bodies.is_empty():
				global_position = position_before_picked_up
			picked_up = false
			snap_to_grid = true

func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int):
	if Input.is_action_just_pressed('mouse_click') and can_be_picked_up and not picked_up:
		position_before_picked_up = global_position
		picked_up = true
		snap_to_grid = false

func _on_area_entered(_area: Area2D):
	if _area not in entered_bodies:
		entered_bodies.append(_area)

func _on_area_exited(_area: Area2D):
	if _area in entered_bodies:
		entered_bodies.erase(_area)

func snap_to_grid_now():
	var _grid_x = roundf((global_position.x - cell_size * grid_snap_offset.x - origin_point.x) / float(cell_size))
	var _grid_y = roundf((global_position.y - cell_size * grid_snap_offset.y - origin_point.y) / float(cell_size))
	var _grid_coordinate = Vector2( int(_grid_x), int(_grid_y)) + grid_snap_offset
	global_position = Vector2(origin_point) + Vector2(cell_size * _grid_coordinate.x, cell_size * _grid_coordinate.y)
