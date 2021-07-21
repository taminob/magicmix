extends Node

func error(error_string: String):
	print("error: " + error_string)

func warning(warning_string: String):
	print("warning: " + warning_string)

func log(log_string: String):
	print("log: " + log_string)

func test(out):
	var s = ""
	for x in out:
		s = s + str(x)
	print(s)

func error_test(error_code: int):
	if(error_code != OK):
		error("an unknown error occurred; code: " + str(error_code))

func debug_assert(condition: bool, msg: String):
	assert(condition, msg)

func assert(condition: bool, msg: String):
	assert(condition, msg)
