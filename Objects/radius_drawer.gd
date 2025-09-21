@tool
extends Node2D

@export var radius_color: Color
@onready var monument: MonumentObject = $".."
var grid_controller: GridController
var cell_size: int

func _ready() -> void:
	grid_controller = GridController.instance
	if grid_controller and is_instance_valid(grid_controller):
		cell_size = grid_controller.cell_size
	else:
		# Fallback if grid controller isn't available yet
		call_deferred("_retry_setup")

func _retry_setup() -> void:
	if not grid_controller or not is_instance_valid(grid_controller):
		grid_controller = GridController.instance
		if grid_controller and is_instance_valid(grid_controller):
			cell_size = grid_controller.cell_size

func _draw() -> void:
	# Safety checks
	if not monument or not grid_controller or not is_instance_valid(grid_controller):
		return
		
	var radius_cells: int = monument.radius_cells
	
	# Get the monument's grid position
	var monument_world_pos = monument.global_position
	var monument_grid_pos = Vector2i(
		(monument_world_pos.x - grid_controller.origin_point.x) / cell_size,
		(monument_world_pos.y - grid_controller.origin_point.y) / cell_size
	)
	
	for i in range(-radius_cells, radius_cells + 1):
		for ii in range(-radius_cells, radius_cells + 1):
			if(pow(i, 2) + pow(ii, 2) < pow(radius_cells, 2)):
				# Calculate the actual grid position for this cell
				var cell_grid_pos = Vector2i(monument_grid_pos.x + i, monument_grid_pos.y + ii)
				
				# Check if this cell is within grid boundaries
				if _is_cell_within_grid(cell_grid_pos):
					@warning_ignore("integer_division")
					var rect: Rect2 = Rect2(
						Vector2(i * cell_size - cell_size/2, ii * cell_size - cell_size/2), 
						Vector2(cell_size, cell_size)
					)
					draw_rect(rect, radius_color)

func _is_cell_within_grid(grid_pos: Vector2i) -> bool:
	if not grid_controller or not is_instance_valid(grid_controller):
		return false
		
	return (grid_pos.x >= 0 and 
			grid_pos.x < grid_controller.grid_size.x and 
			grid_pos.y >= 0 and 
			grid_pos.y < grid_controller.grid_size.y)

func _process(delta: float):
	# Only queue redraw if everything is valid
	if monument and grid_controller and is_instance_valid(grid_controller):
		queue_redraw()
