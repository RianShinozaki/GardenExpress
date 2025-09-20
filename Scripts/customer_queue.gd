@tool
class_name CustomerQueue extends Node2D

@export var grid_controller: grid_controller
@export var customer_scene: PackedScene
@export var customer_queue: CustomerQueue

var spawn_interval: float = 5.0
var spawn_timer: float = 0.0
var next_column: int = 0

func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		_spawn_customer()
		spawn_timer = spawn_interval

func _spawn_customer() -> void:
	if customer_scene == null:
		push_error("CustomerQueue: customer_scene is not assigned!")
		return
	
	var customer = customer_scene.instantiate() as CustomerObject
	customer.in_queue = true
	
	# place in bottom row of the grid
	var grid = grid_controller.instance
	var bottom_row = grid.gridSize.y - 1
	var grid_position = Vector2i(next_column, bottom_row)
	customer.global_position = grid.originPoint + grid_position * grid.cellSize
	
	# add to BoardObjects node
	var board = get_tree().get_root().get_node("Game/BoardObjects")
	board.add_child(customer)
	
	# move to next column
	next_column += 1
	if next_column >= grid.gridSize.x:
		next_column = 0   # wrap around if row is full
