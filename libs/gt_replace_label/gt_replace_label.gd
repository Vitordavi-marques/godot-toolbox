extends Label
class_name GTReplaceLabel

export (String) var original_text

func apply_text(params: Array):
	text = original_text % params
