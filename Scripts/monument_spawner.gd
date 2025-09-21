class_name MonumentSpawner extends Node2D

@export var monument_scene: PackedScene
@export var grid_controller: GridController
@export var board_objects_parent: Node2D
@export var min_distance_between_monuments: int = 4  # Minimum cells between monuments
@export var edge_buffer: int = 1  # Minimum distance from grid edges

var monument_configs: Array[Dictionary] = [
	{"type": MonumentObject.MONUMENT_TYPE.OUTHOUSE, "radius": 2},
	{"type": MonumentObject.MONUMENT_TYPE.FOUNTAIN, "radius": 3},
	{"type": MonumentObject.MONUMENT_TYPE.MOUNTAIN, "radius": 2}
]

var occupied_positions: Array[Vector2i] = []

func _ready() -> void:
	if not grid_controller:
		grid_controller = GridController.instance
	
	call_deferred("_spawn_initial_monuments")

func _spawn_initial_monuments() -> void:
	if not monument_scene:
		push_error("MonumentSpawner: monument_scene is not assigned!")
		return
	
	print("Spawning initial monuments...")
	
	# Clear any existing occupied positions
	occupied_positions.clear()
	
	# Generate random positions for each monument
	for config in monument_configs:
		var random_position = _get_random_valid_position()
		if random_position != Vector2i(-1, -1):  # Valid position found
			_spawn_monument_at_position(random_position, config)
		else:
			print("Could not find valid position for monument of type: ", config.type)

func _get_random_valid_position() -> Vector2i:
	var max_attempts = 100  # Prevent infinite loops
	var attempts = 0
	
	while attempts < max_attempts:
		var random_x = randi() % grid_controller.grid_size.x
		var random_y = randi() % grid_controller.grid_size.y
		var potential_position = Vector2i(random_x, random_y)
		
		if _is_position_valid(potential_position) and _is_position_available(potential_position):
			return potential_position
		
		attempts += 1
	
	# Return invalid position if no valid spot found
	return Vector2i(-1, -1)

func _is_position_available(grid_pos: Vector2i) -> bool:
	# Check if position is too close to existing monuments
	for occupied_pos in occupied_positions:
		var distance = grid_pos.distance_to(occupied_pos)
		if distance < min_distance_between_monuments:
			return false
	
	return true

func _spawn_monument_at_position(grid_pos: Vector2i, config: Dictionary) -> void:
	if not _is_position_valid(grid_pos):
		print("Invalid position for monument: ", grid_pos)
		return
	
	var monument = monument_scene.instantiate() as MonumentObject
	
	monument.monument_type = config.type
	monument.radius_cells = config.radius
	
	var world_position = grid_controller.origin_point + grid_pos * grid_controller.cell_size
	monument.global_position = world_position
	
	board_objects_parent.add_child(monument)
	
	# Mark this position as occupied
	occupied_positions.append(grid_pos)
	
	print("Spawned monument at grid position: ", grid_pos)

func _is_position_valid(grid_pos: Vector2i) -> bool:
	# Basic grid bounds check
	if grid_pos.x < 0 or grid_pos.x >= grid_controller.grid_size.x:
		return false
	if grid_pos.y < 0 or grid_pos.y >= grid_controller.grid_size.y:
		return false
	
	# Prevent spawning on the bottom row (original constraint)
	if grid_pos.y >= grid_controller.grid_size.y - 1:
		return false
	
	# Keep monuments away from edges
	if grid_pos.x < edge_buffer:  # Left edge
		return false
	if grid_pos.x >= grid_controller.grid_size.x - edge_buffer:  # Right edge
		return false
	if grid_pos.y < edge_buffer:  # Top edge
		return false
	if grid_pos.y >= grid_controller.grid_size.y - edge_buffer - 1:  # Bottom edge (accounting for bottom row restriction)
		return false
	
	return true

# Optional: Function to respawn monuments with new random positions
func respawn_monuments() -> void:
	# Remove existing monuments
	for child in board_objects_parent.get_children():
		if child is MonumentObject:
			child.queue_free()
	
	occupied_positions.clear()
	
	# Wait a frame for cleanup, then spawn new ones
	await get_tree().process_frame
	_spawn_initial_monuments()
