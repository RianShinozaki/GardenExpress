extends HBoxContainer
class_name CustomerQueue

@export var customer_scene: PackedScene
var spawn_interval: float = 10.0
var spawn_timer: float = 0.0


func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		_spawn_customer()
		spawn_timer = spawn_interval

func _spawn_customer() -> void:
	var customer = customer_scene.instantiate()
	print(customer)
	customer.in_queue = true
	add_child(customer)
