@tool
class_name grid_controller extends Node2D

@export var originPoint: Vector2i
@export var gridSize: Vector2i
@export var cellSize: int
@export var lineThickness: int

static var instance
func _enter_tree() -> void:
	instance = self
	
func _draw():
	draw_line(Vector2(0,0), Vector2(1, 1), Color.BLACK, lineThickness)
	for i in range(gridSize.x+1):
		var origin = originPoint + Vector2i(i * cellSize, 0)
		var destination = originPoint + Vector2i(i * cellSize, gridSize.y * cellSize)
		draw_line(origin, destination, Color.BLACK, lineThickness)
	for i in range(gridSize.y+1):
		var origin = originPoint + Vector2i(0, i * cellSize)
		var destination = originPoint + Vector2i(gridSize.x * cellSize, i * cellSize)
		draw_line(origin, destination, Color.BLACK, lineThickness)

func _process(_delta: float):
	queue_redraw()
