class_name CustomerObject
extends GridObject

# dictionary of monuments and the time left to visit
@export var monuments: Dictionary
@export var time_remaining: float
var in_queue: bool = false
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	super._ready()
	radius = 100
	
	progress_bar.max_value = time_remaining
	progress_bar.value = time_remaining
	
	# choose random monuments to visit
	#var all_monuments = ["tree", "fountain", "flowers"] # replace this when implementing monuments
	var num_to_visit = randi() % 4 + 1
	
	time_remaining = 10 * num_to_visit + 5
	
	#all_monuments.shuffle()
	#for i in range(num_to_visit):
		#monuments[all_monuments[i]] = 10.0;
		
	print("%s wants to visit %d monuments." % [name, monuments.size()])

func _process(delta: float) -> void:
	super._process(delta)
	
	# reduce remaining time
	time_remaining -= delta
	progress_bar.value = time_remaining
	if (time_remaining <= 0):
		_leave()
	
	_check_satisfaction(delta)

func _check_satisfaction(delta) -> void:
#	decrease time the player needs to stay by a monument
	for monument in monuments.keys():
		if global_position.distance_to(monument.global_position) <= radius:
			monuments[monument] -= delta
	
	# check if all monuments have been visited
	var visited_all = true
	for monument in monuments.keys():
		if monuments[monument] > 0.0:
			visited_all = false
			break
	
	if visited_all:
		_leave()
		
func _on_drag_start() -> void:
	if in_queue:
		in_queue = false
		var queue_parent = get_parent()
		queue_parent.remove_child(self)
		get_tree().get_root().get_node("BoardObjects").add_child(self)

func _leave() -> void:
	# called when a customer is satisfied / out of time
	queue_free()
