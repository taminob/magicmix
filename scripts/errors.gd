extends Node

func error(error_string):
	print("error: " + error_string)

func warning(warning_string):
	print("warning: " + warning_string)

func log(log_string):
	print("log: " + log_string)

func test(out):
	var s = ""
	for x in out:
		s = s + str(x)
	print(s)
