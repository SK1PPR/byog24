extends Line2D

var queue: Array = []
@export var MAX_LENGTH : int = 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Get the parent's global position
	var pos = get_parent().global_position

	# Only add the new position if it differs from the last one to avoid duplicates
	if queue.size() == 0 or pos != queue[0]:
		queue.push_front(pos)

	# Ensure the queue doesn't exceed the max length
	if queue.size() > MAX_LENGTH:
		queue.pop_back()

	# Clear points only when the queue is updated, and redraw the line
	clear_points()
	for point in queue:
		add_point(point)
