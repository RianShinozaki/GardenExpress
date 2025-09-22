class_name Game

extends Node2D

@export var game_over_scene: PackedScene
static var instance: Game

func _enter_tree() -> void:
	instance = self

func do_game_over_helper() -> void:
	get_tree().change_scene_to_file("res://Maps/GameOver.tscn")

static func do_game_over() -> void:
	instance.do_game_over_helper()
	GameController.active_monuments.clear()
