extends Node
class_name GTFormula

signal result(value)
signal succeded()
signal failed()

enum FORMULA_COMPARE_TYPE {
	EQUALS,
	NOT_EQUALS,
	GREATER_THAN,
	GREATER_OR_EQUAL,
	LESS_THAN,
	LESS_OR_EQUAL}

export (FORMULA_COMPARE_TYPE) var formula_compare_type setget set_formula_compare_type # The formula evaluation type
export (bool) var emit_result = true # If the result should be emitted in a signal
export (float) var expected_value = 0 setget set_expected_value # The expected numerical value for the formula

func set_formula_compare_type(_value):
	formula_compare_type = _value

func set_expected_value(_value):
	expected_value = _value

# Calculates the result by evaluating 'current_value' in this formula
func validate(current_value: float) -> bool:
	var result = true
	match formula_compare_type:
		FORMULA_COMPARE_TYPE.EQUALS:
			result = current_value == expected_value
		FORMULA_COMPARE_TYPE.NOT_EQUALS:
			result = current_value != expected_value
		FORMULA_COMPARE_TYPE.GREATER_THAN:
			result = current_value > expected_value
		FORMULA_COMPARE_TYPE.GREATER_OR_EQUAL:
			result = current_value >= expected_value
		FORMULA_COMPARE_TYPE.LESS_THAN:
			result = current_value < expected_value
		FORMULA_COMPARE_TYPE.LESS_OR_EQUAL:
			result = current_value <= expected_value
	if emit_result:
		emit_signal("result", result)
		if result:
			emit_signal("succeded")
		else:
			emit_signal("failed")
	return result
