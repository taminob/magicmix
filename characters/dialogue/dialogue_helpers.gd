class_name dialogue_helpers

static func stranger_greeting() -> String:
	return util.random_element([
		"Hello, stranger!",
		"A pleasure to meet you, stranger!"
	])

static func friendly_greeting() -> String:
	return util.random_element([
		"Hello, my friend!",
		"Hello, {partner}!"
	])

static func neutral_greetings() -> String:
	return util.random_element([
		"I greet you!"
	])

static func hostile_greetings() -> String:
	return util.random_element([
		"What do you want?"
	])

static func murder_witness() -> String:
	return util.random_element([
		"M U R D E R E R !"
	])

static func long_time_not_seen() -> String:
	return util.random_element([
		"Oh, it's you - has been a long time!",
		"Where were you?"
	])

static func no_time() -> String:
	return util.random_element([
		"No time, later!",
		"Later!",
		"Another time!"
	])
