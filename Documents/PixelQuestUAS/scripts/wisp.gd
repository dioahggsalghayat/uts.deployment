extends Node2D
## Companion cahaya yang melayang di sisi pemain.

var _home_position: Vector2
var _phase: float = 0.0


func _ready() -> void:
	_home_position = position
	_phase = randf() * TAU


func _process(_delta: float) -> void:
	var time := Time.get_ticks_msec() * 0.001 + _phase
	position = _home_position + Vector2(sin(time * 0.8) * 5.0, sin(time * 1.7) * 7.0)
