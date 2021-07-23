extends Node

func fract(value: float) -> float:
	return value - floor(value)

func max(first: float, second: float, third: float) -> float:
	return max(first, max(second, third))
