extends Area2D

var cell_size: int
var origin_point: Vector2i
@export var grid_snap_offset: Vector2

func _ready() -> void:
	cell_size = GridController.instance.cell_size
	origin_point = GridController.instance.origin_point
	
func _process(_delta: float) -> void:
	global_position = get_parent().global_position
	
	var _grid_x = roundf((global_position.x - cell_size * grid_snap_offset.x - origin_point.x) / float(cell_size))
	var _grid_y = roundf((global_position.y - cell_size * grid_snap_offset.y - origin_point.y) / float(cell_size))
	var _grid_coordinate = Vector2( int(_grid_x), int(_grid_y)) + grid_snap_offset
	global_position = Vector2(origin_point) + Vector2(cell_size * _grid_coordinate.x, cell_size * _grid_coordinate.y)
