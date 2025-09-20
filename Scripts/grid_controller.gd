@tool
class_name GridController extends Node2D

@export var origin_point: Vector2i
@export var grid_size: Vector2i
@export var cell_size: int
@export var line_thickness: int
@export var line_color: Color

static var instance
func _enter_tree() -> void:
	instance = self
	
func _draw():
	draw_line(Vector2(0,0), Vector2(1, 1), line_color, line_thickness)
	for i in range(grid_size.x+1):
		var origin = origin_point + Vector2i(i * cell_size, 0)
		var destination = origin_point + Vector2i(i * cell_size, grid_size.y * cell_size)
		draw_line(origin, destination, line_color, line_thickness)
	for i in range(grid_size.y+1):
		var origin = origin_point + Vector2i(0, i * cell_size)
		var destination = origin_point + Vector2i(grid_size.x * cell_size, i * cell_size)
		draw_line(origin, destination, line_color, line_thickness)

func _process(_delta: float):
	queue_redraw()
