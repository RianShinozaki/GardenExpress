class_name MonumentObject

extends GridObject

enum MONUMENT_TYPE {OUTHOUSE, MOUNTAIN, FOUNTAIN, CONCESSIONS}

@export var monument_type: MONUMENT_TYPE : set = set_monument_type
@export var radius_cells: int
@export var radius_color: Color

# Sprite resources for each monument type
@export var outhouse_sprite: Texture2D
@export var mountain_sprite: Texture2D
@export var fountain_sprite: Texture2D
@export var concessions_sprite: Texture2D

# Sprite scaling options
@export var sprite_scale: Vector2 = Vector2(1.0, 1.0)
@export var auto_resize_to_cell: bool = false

@onready var sprite_node: Sprite2D = $Sprite2D

func _ready() -> void:
	super._ready()
	# Apply the sprite when the node is ready
	_update_sprite()

func _enter_tree() -> void:
	GameController.active_monuments.append(self)

func set_monument_type(new_type: MONUMENT_TYPE) -> void:
	monument_type = new_type
	# Update sprite immediately if the node is ready
	if sprite_node:
		_update_sprite()

func _update_sprite() -> void:
	if not sprite_node:
		return
	
	# Set the sprite based on monument type
	match monument_type:
		MONUMENT_TYPE.OUTHOUSE:
			if outhouse_sprite:
				sprite_node.texture = outhouse_sprite
			else:
				print("Warning: No outhouse sprite assigned!")
		
		MONUMENT_TYPE.MOUNTAIN:
			if mountain_sprite:
				sprite_node.texture = mountain_sprite
			else:
				print("Warning: No mountain sprite assigned, using outhouse as fallback")
				sprite_node.texture = outhouse_sprite
		
		MONUMENT_TYPE.FOUNTAIN:
			if fountain_sprite:
				sprite_node.texture = fountain_sprite
			else:
				print("Warning: No fountain sprite assigned, using outhouse as fallback")
				sprite_node.texture = outhouse_sprite
		
		MONUMENT_TYPE.CONCESSIONS:
			if concessions_sprite:
				sprite_node.texture = concessions_sprite
			else:
				print("Warning: No concessions sprite assigned, using outhouse as fallback")
				sprite_node.texture = outhouse_sprite
	
	# Apply scaling
	_apply_sprite_scaling()

func _apply_sprite_scaling() -> void:
	if not sprite_node or not sprite_node.texture:
		return
	
	if auto_resize_to_cell:
		# Automatically resize to fit the grid cell
		var texture_size = sprite_node.texture.get_size()
		var target_size = Vector2(cell_size * 0.8, cell_size * 0.8)  # 80% of cell size
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
	return (pow(_offset.x, 2) + pow(_offset.y, 2) < pow(radius_cells, 2))
