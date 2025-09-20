class_name MonumentObject

extends GridObject

enum MONUMENT_TYPE {OUTHOUSE, MOUNTAIN, FOUNTAIN, CONCESSIONS}

@export var monument_type: MONUMENT_TYPE
@export var radius_cells: int
@export var radius_color: Color

func _enter_tree() -> void:
	GameController.active_monuments.append(self)

func check_in_range(_position: Vector2) -> bool:
	var _offset = (global_position - _position) / cell_size
	return (pow(_offset.x, 2) + pow(_offset.y, 2) < pow(radius_cells, 2))
