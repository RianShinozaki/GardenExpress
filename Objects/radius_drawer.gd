@tool

extends Node2D

@export var radius_color: Color
@onready var monument: MonumentObject = $".."
@onready var grid_controller: GridController = GridController.instance
@onready var cell_size = grid_controller.cell_size

func _draw() -> void:
	var _radius_cells: int = monument.radius_cells
	for i in range(-_radius_cells, _radius_cells):
		for ii in range(-_radius_cells, _radius_cells):
			if(pow(i, 2) + pow(ii, 2) < pow(_radius_cells, 2)):
				@warning_ignore("integer_division")
				var _rect: Rect2 = Rect2(Vector2(i * cell_size - cell_size/2, ii * cell_size - cell_size/2), Vector2(cell_size, cell_size))
				draw_rect(_rect, radius_color)

func _process(_delta: float):
	queue_redraw()
