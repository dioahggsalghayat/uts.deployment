extends Area2D
## Peluru energi horizontal yang menghilang saat mengenai musuh, lantai, atau tepi layar.

const SPEED: float = 500.0

var direction: float = 1.0

@onready var screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	screen_notifier.screen_exited.connect(queue_free)


func _physics_process(delta: float) -> void:
	position.x += direction * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		_hit_target(body)
	elif body is StaticBody2D:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		_hit_target(area)


func _hit_target(target: Node) -> void:
	GameManager.play_sfx(&"enemy_hit")
	if target.has_method("take_damage"):
		target.take_damage(1)
	queue_free()
