extends Node

func fract(value: float) -> float:
	return value - floor(value)

func max(first: float, second: float, third: float) -> float:
	return max(first, max(second, third))

func random_element(array: Array):
	return array[randi() % array.size()]

# script can be obtained via get_script()
func absolute_path(script: Resource, relative_path: String) -> String:
	return script.resource_path.get_base_dir() + "/" + relative_path
