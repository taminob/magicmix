extends Node

func error(error_str: String):
	print("error: " + error_str)

func warning(warning_string: String):
	print("warning: " + warning_string)

func logging(log_string: String):
	print("log: " + log_string)

func debug_output(out):
	var s = ""
	for x in out:
		s = s + str(x)
	print(s)

func error_test(error_code: int):
	if(error_code != OK):
		error("an unknown error occurred; code: " + str(error_code))

func debug_assert(condition: bool, msg: String):
	assert(condition, msg)

func assert_always(condition: bool, msg: String):
	assert(condition, msg)
