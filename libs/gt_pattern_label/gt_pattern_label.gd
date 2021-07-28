extends Label
class_name GTPatternLabel

export (String) var pattern_text

func apply_text_simple(t1, t2 = null, t3 = null) -> void:
	if t1 and t2 and t3:
		apply_text([t1, t2, t3])
	elif t1 and t2:
		apply_text([t1, t2])
	else:
		apply_text([t1])

func apply_text(params: Array) -> void:
	text = pattern_text % params
