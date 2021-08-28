extends Node
class_name GTFormula

signal result(value)
signal succeded()
signal failed()

enum FORMULA_TYPE {
	EQUALS,
	NOT_EQUALS,
	GREATER_THAN,
	GREATER_OR_EQUAL,
	LESS_THAN,
	LESS_OR_EQUAL}

export (FORMULA_TYPE) var formula_type
export (bool) var emit_result = true
export (float) var expected_value = 0

func validate(current_value: float) -> bool:
	var result = true
	match formula_type:
		FORMULA_TYPE.EQUALS:
			result = current_value == expected_value
		FORMULA_TYPE.NOT_EQUALS:
			result = current_value != expected_value
		FORMULA_TYPE.GREATER_THAN:
			result = current_value > expected_value
		FORMULA_TYPE.GREATER_OR_EQUAL:
			result = current_value >= expected_value
		FORMULA_TYPE.LESS_THAN:
			result = current_value < expected_value
		FORMULA_TYPE.LESS_OR_EQUAL:
			result = current_value <= expected_value
	if emit_result:
		emit_signal("result", result)
		if result:
			emit_signal("succeded")
		else:
			emit_signal("failed")
	return result
