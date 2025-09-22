class_name Game

extends Node2D

@export var game_over_scene: PackedScene
@onready var satisfied_label: Label
static var instance: Game
var satisfied_customers: int = 0

func _ready() -> void:
	instance = self
	satisfied_label = get_tree().get_root().get_node("Game/VBoxContainer/SatisfiedCustomersLabel")
	update_satisfied_label()

func add_satisfied_customer() -> void:
	satisfied_customers += 1
	update_satisfied_label()

func update_satisfied_label() -> void:
	if is_instance_valid(satisfied_label):
		satisfied_label.text = "Satisfied Customers: %d" % satisfied_customers

func do_game_over_helper() -> void:
	get_tree().change_scene_to_file("res://Maps/GameOver.tscn")

static func do_game_over() -> void:
	instance.do_game_over_helper()
	GameController.active_monuments.clear()
