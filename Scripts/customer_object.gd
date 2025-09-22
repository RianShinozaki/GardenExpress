class_name CustomerObject extends GridObject

# dictionary of monuments and the time left to visit
@export var monuments_to_visit: Array[MonumentData] = []
@export var monuments_time: Array[float] = []
@export var time_remaining: float = 10.0
@export var in_queue: bool = true
@export var monument_visit_time: float = 10.0
@onready var patience_bar: ProgressBar = $ProgressBar
@onready var desire_icon = $PanelContainer/DesireList/DesireIcon

var mouse_over: bool
var show_desire: bool

func _ready() -> void:
	super._ready()
	patience_bar.visible = true
	radius = 100

	# collect all monuments
	var all_monuments: Array[MonumentData] = []
	for m: MonumentObject in GameController.active_monuments:
		all_monuments.append(m.monument_data)

	all_monuments.shuffle()

	# pick a random 1–3, clamped by available monuments
	var num_monuments := randi_range(1, 3)
	num_monuments = min(num_monuments, all_monuments.size())

	monuments_to_visit = all_monuments.slice(0, num_monuments)

	# patience is multiplied by number of monuments
	patience_bar.max_value = time_remaining * monuments_to_visit.size()
	time_remaining = patience_bar.max_value
	patience_bar.value = time_remaining

	# add icons for chosen monuments
	for i in range(monuments_to_visit.size()):
		var _desire_icon: TextureRect = desire_icon.duplicate() as TextureRect
		get_node("PanelContainer/DesireList").add_child(_desire_icon)
		_desire_icon.texture = monuments_to_visit[i].texture
		monuments_time.append(monument_visit_time)

	desire_icon.queue_free()

	area.mouse_entered.connect(mouse_entered)
	area.mouse_exited.connect(mouse_exited)

func _process(delta: float) -> void:
	super._process(delta)

	# check if customer is currently in range of something they want
	var in_range := false
	var _monuments_in_range = detect_monuments(global_position)
	for _monument in _monuments_in_range:
		if monuments_to_visit.has(_monument.monument_data):
			in_range = true
			break

	# show desires if: mouse over OR picked up OR not in range
	show_desire = mouse_over or picked_up or not in_range
	get_node("PanelContainer/DesireList").visible = show_desire

	# reduce remaining time
	time_remaining -= delta
	patience_bar.value = time_remaining
	if time_remaining <= 0:
		Game.do_game_over()

	if monuments_to_visit.is_empty():
		_leave()

	if picked_up:
		return

	for _monument in _monuments_in_range:
		var _monument_data: MonumentData = _monument.monument_data
		var _monument_index = monuments_to_visit.find(_monument_data)
		if _monument_index == -1:
			continue
		monuments_time[_monument_index] -= delta
		var _monument_progress: ProgressBar = get_node("PanelContainer/DesireList").get_child(_monument_index).get_node("ProgressBar")
		_monument_progress.value = 1 - (monuments_time[_monument_index] / monument_visit_time)
		if monuments_time[_monument_index] <= 0.0:
			get_node("PanelContainer/DesireList").get_child(_monument_index).queue_free()
			monuments_to_visit.remove_at(_monument_index)
			monuments_time.remove_at(_monument_index)

func _leave() -> void:
	# called when a customer is satisfied / out of time
	if monuments_to_visit.is_empty():
		# satisfied customer
		GameController.add_satisfied_customer()
	print("Satisfied customers: %d" % GameController.satisfied_customers)
	queue_free()

func detect_monuments(_position: Vector2) -> Array[MonumentObject]:
	var _monument_array: Array[MonumentObject] = []
	for _monument_object: MonumentObject in GameController.active_monuments:
		if _monument_object.check_in_range(_position):
			_monument_array.append(_monument_object)
	return _monument_array

func mouse_entered() -> void:
	mouse_over = true

func mouse_exited() -> void:
	mouse_over = false
