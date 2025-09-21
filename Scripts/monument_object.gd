class_name MonumentObject

extends GridObject

@export var monument_data: MonumentData
@export var radius_color: Color

# Sprite resources for each monument type
@export var outhouse_sprite: Texture2D
@export var mountain_sprite: Texture2D
@export var fountain_sprite: Texture2D
@export var concessions_sprite: Texture2D

# Sprite scaling options
@export var sprite_scale: Vector2 = Vector2(1.0, 1.0)
@export var auto_resize_to_cell: bool = true

@onready var sprite_node: Sprite2D = $Sprite2D

func _ready() -> void:
	super._ready()
	# Apply the sprite when the node is ready
	_update_sprite()

func _enter_tree() -> void:
	GameController.active_monuments.append(self)

func set_monument_data(_monument_data: MonumentData) -> void:
	monument_data = _monument_data

func _update_sprite() -> void:
	# Set the sprite based on monument type
	sprite_node.texture = monument_data.texture
	
	# Apply scaling
	_apply_sprite_scaling()

func _apply_sprite_scaling() -> void:
	if auto_resize_to_cell:
		# Automatically resize to fit the grid cell
		var texture_size = sprite_node.texture.get_size()
		var target_size = Vector2(cell_size * 1.2, cell_size * 1.2)  # 80% of cell size
		var scale_factor = Vector2(
			target_size.x / texture_size.x,
			target_size.y / texture_size.y
		)
		sprite_node.scale = scale_factor
	else:
		# Use manual scale
		sprite_node.scale = sprite_scale

func check_in_range(_position: Vector2) -> bool:
	var _offset = (global_position - _position) / cell_size
	return (pow(_offset.x, 2) + pow(_offset.y, 2) < pow(monument_data.radius, 2))
