extends Line2D

@export var point_length: int = 50
var start_pos := Vector2.ZERO

func _ready():
	# Set the starting position to where the parent is at the beginning
	start_pos = get_parent().global_position
	
	# Make sure the Line2D draws from its local position
	global_position = start_pos

func _process(delta: float) -> void:
	# Get the parent’s current global position
	var current_pos = get_parent().global_position
	
	# Convert the current position to relative coordinates (relative to Line2D’s global_position)
	var relative_point = current_pos - global_position
	
	# Add the relative point to the line
	add_point(relative_point)
	
	# Keep the trail at a max length
	while get_point_count() > point_length:
		remove_point(0)
