class_name action

class condition:
	var mean: float
	var deviation: float

	static func create(new_mean: float, new_deviation:float=0.0) -> condition:
		var new_condition
		new_condition.mean = new_mean
		new_condition.deviation = new_deviation
		return new_condition

	func fulfilled(value: float) -> bool:
		return value < mean + deviation && value > mean - deviation

static func precondition() -> Dictionary:
	return {}

static func postcondition() -> Dictionary:
	return {}

func do(_delta: float):
	pass
