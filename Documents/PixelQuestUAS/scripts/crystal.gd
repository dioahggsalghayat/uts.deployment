extends Area2D
## Pickup Royal Crystal yang memperbarui status permainan saat disentuh pemain.

@export var points: int = 100
@export var is_royal: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameManager.collect_crystal(points, is_royal)
		queue_free()
