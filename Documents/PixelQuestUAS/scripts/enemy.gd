extends Area2D
## Musuh sederhana yang berpatroli bolak-balik dan melukai pemain saat disentuh.

const SPEED: float = 60.0
const PATROL_DISTANCE: float = 120.0

var direction: float = 1.0
var patrol_start_x: float
var health: int = 1


func _ready() -> void:
	add_to_group("enemies")
	patrol_start_x = position.x
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position.x += direction * SPEED * delta
	if position.x >= patrol_start_x + PATROL_DISTANCE:
		position.x = patrol_start_x + PATROL_DISTANCE
		direction = -1.0
	elif position.x <= patrol_start_x - PATROL_DISTANCE:
		position.x = patrol_start_x - PATROL_DISTANCE
		direction = 1.0


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameManager.take_damage(20)


func take_damage(amount: int = 1) -> void:
	health -= amount
	if health <= 0:
		queue_free()
