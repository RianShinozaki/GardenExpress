class_name Game
extends Node2D

@export var game_over_scene: PackedScene
static var instance: Game

@onready var satisfied_label: Label
var satisfied_customers: int = 0

@export var bg_music: AudioStream
var music_player: AudioStreamPlayer
@export var cash_sfx: AudioStream

func _ready() -> void:
	instance = self
	satisfied_label = get_tree().get_root().get_node("Game/VBoxContainer/SatisfiedCustomersLabel")
	update_satisfied_label()

	# setup and play background music
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = bg_music
	music_player.play()

func add_satisfied_customer() -> void:
	satisfied_customers += 1
	var audio = AudioStreamPlayer.new()
	Game.instance.add_child(audio)
	audio.stream = cash_sfx
	audio.play()
	update_satisfied_label()
	

func update_satisfied_label() -> void:
	if is_instance_valid(satisfied_label):
		satisfied_label.text = "Satisfied Customers: %d" % satisfied_customers

func do_game_over_helper() -> void:
	get_tree().change_scene_to_file("res://Maps/GameOver.tscn")

static func do_game_over() -> void:
	instance.do_game_over_helper()
	GameController.active_monuments.clear()
