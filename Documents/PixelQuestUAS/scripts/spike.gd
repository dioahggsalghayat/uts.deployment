extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.take_damage(15)
		if body is CharacterBody2D:
			var recoil_direction := signf(body.global_position.x - global_position.x)
			if is_zero_approx(recoil_direction):
				recoil_direction = 1.0
			body.velocity = Vector2(recoil_direction * 150.0, -180.0)
