class_name CustomerQueue extends Node2D

@export var grid_controller: GridController
@export var customer_scene: PackedScene
@export var customer_queue: CustomerQueue
@export var board_objects_parent: Node2D

var spawn_interval: float = 5.0
var spawn_timer: float = 0.0
var next_column: int = 0

func _ready() -> void:
	grid_controller = GridController.instance

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
	var bottom_row = grid_controller.grid_size.y - 1
	var grid_position = Vector2i(next_column, bottom_row)
	customer.global_position = grid_controller.origin_point + grid_position * grid_controller.cell_size
	
	# add to BoardObjects node
	board_objects_parent.add_child(customer)
	
	# move to next column
	next_column += 1
	if next_column >= grid_controller.grid_size.x:
		next_column = 0   # wrap around if row is full
