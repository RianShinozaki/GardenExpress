class_name CustomerObject extends GridObject

# dictionary of monuments and the time left to visit
@export var monuments_to_visit: Array[MonumentData]
@export var monuments_time: Array[float]
@export var time_remaining: float = 10.0
@export var in_queue: bool = true
@export var monument_visit_time: float = 10.0
@onready var patience_bar: ProgressBar = $ProgressBar
@onready var desire_icon = $DesireList/DesireIcon

func _ready() -> void:
	super._ready()
	patience_bar.visible = true
	
	radius = 100
	
	patience_bar.max_value = time_remaining
	patience_bar.value = time_remaining
	time_remaining = time_remaining * monuments_to_visit.size()
	
	for i in range(monuments_to_visit.size()):
		var _desire_icon: TextureRect = desire_icon.duplicate() as TextureRect
		get_node("DesireList").add_child(_desire_icon)
		_desire_icon.texture = monuments_to_visit[i].texture
		monuments_time.append(monument_visit_time);
	
	desire_icon.queue_free()
	#print("%s wants to visit %d monuments." % [name, monuments.size()])

func _process(delta: float) -> void:
	super._process(delta)
	
	# reduce remaining time
	time_remaining -= delta
	patience_bar.value = time_remaining
	if (time_remaining <= 0):
		_leave()
	
	if picked_up: return
	var _monuments_in_range = detect_monuments(global_position)
	for _monument in _monuments_in_range:
		
		var _monument_data: MonumentData = _monument.monument_data
		var _monument_index = monuments_to_visit.find(_monument_data)
		if _monument_index == -1: return
		monuments_time[_monument_index] -= delta
		var _monument_progress: ProgressBar = get_node("DesireList").get_child(_monument_index).get_node("ProgressBar")
		_monument_progress.value = 1 - (monuments_time[_monument_index] / monument_visit_time)
		if monuments_time[_monument_index] <= 0.0:
			get_node("DesireList").get_child(_monument_index).queue_free()
			monuments_to_visit.remove_at(_monument_index)
			monuments_time.remove_at(_monument_index)
		
	if monuments_to_visit.is_empty():
		_leave()

func _leave() -> void:
	# called when a customer is satisfied / out of time
	queue_free()
	
func detect_monuments(_position: Vector2) -> Array[MonumentObject]:
	var _monument_array: Array[MonumentObject] = []
	for _monument_object: MonumentObject in GameController.active_monuments:
		if _monument_object.check_in_range(_position):
			_monument_array.append(_monument_object)
	return _monument_array
		
