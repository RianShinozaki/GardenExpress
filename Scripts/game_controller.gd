extends Node

var active_monuments: Array[MonumentObject]
var satisfied_customers: int = 0

@onready var satisfied_label: Label

func _ready() -> void:
	satisfied_label = get_tree().get_root().get_node("Game/VBoxContainer/SatisfiedCustomersLabel")
	update_satisfied_label()

func add_satisfied_customer() -> void:
	satisfied_customers += 1
	update_satisfied_label()

func update_satisfied_label() -> void:
	if is_instance_valid(satisfied_label):
		satisfied_label.text = "Satisfied Customers: %d" % satisfied_customers
