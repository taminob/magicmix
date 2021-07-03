extends action

static func precondition() -> Dictionary:
	return {
		#"distance": condition.create(0.5, 0.5)
	}

static func postcondition() -> Dictionary:
	return {}

func do(_delta: float):
	pass
