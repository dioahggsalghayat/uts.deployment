extends Area2D

const SPEED: float = 240.0
var direction: Vector2 = Vector2.LEFT
var lifetime: float = 5.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	global_position += direction * SPEED * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.take_damage(10)
		if body.has_method("screen_shake"):
			body.screen_shake(0.14, 3.0)
		queue_free()
