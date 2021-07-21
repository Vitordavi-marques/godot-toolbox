extends Label
class_name GTPatternLabel

export (String) var pattern_text

func apply_text(params: Array):
	text = pattern_text % params
