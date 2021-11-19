extends Node2D

export (bool) var is_enabled = true # Whether this node is enabled or not
export (Color) var line_color # Color of the line drawn
export (float) var line_width = 8.0 # Width of the lines
export (float) var line_dash = 4.0 # Spacing between lines

func _process(delta):
	if is_enabled:
		update()

func draw_dashed_line(from, to, cap_end = false, antialiased = false):
	var length = (to - from).length()
	var normal = (to - from).normalized()
	var dash_step = normal * line_dash
	
	if length < line_dash: #not long enough to dash
		draw_line(from, to, line_color, line_width, antialiased)
		return

	else:
		var draw_flag = true
		var segment_start = from
		var steps = length/line_dash
		for start_length in range(0, steps + 1):
			var segment_end = segment_start + dash_step
			if draw_flag:
				draw_line(segment_start, segment_end, line_color, line_width, antialiased)

			segment_start = segment_end
			draw_flag = !draw_flag
		
		if cap_end:
			draw_line(segment_start, to, line_color, line_width, antialiased)

# Disables this node's functionality
func disable() -> void:
	is_enabled = false

# Disables this node's functionality
func enable() -> void:
	is_enabled = true
