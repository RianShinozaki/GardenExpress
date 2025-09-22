extends Node2D

@onready var start_button = $Button
@export var next_scene: String

func _ready() -> void:
	start_button.pressed.connect(_pressed)
	
func _pressed() -> void:
	get_tree().change_scene_to_file(next_scene)
