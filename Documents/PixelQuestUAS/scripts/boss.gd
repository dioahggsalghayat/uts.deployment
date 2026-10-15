extends Area2D

signal boss_health_changed(current_hp: int, max_hp: int)
signal boss_defeated

const PROJECTILE_SCENE: PackedScene = preload("res://scenes/BossProjectile.tscn")
const MAX_HEALTH: int = 100
const ATTACK_INTERVAL: float = 2.0

var health: int = MAX_HEALTH
var max_health: int = MAX_HEALTH
var attack_timer: float = ATTACK_INTERVAL

@onready var health_bar: ProgressBar = get_node_or_null("HealthBar") as ProgressBar


func _ready() -> void:
	add_to_group("enemies")
	add_to_group("boss")
	attack_timer = 0.8
	if health_bar != null:
		health_bar.max_value = max_health
		health_bar.value = health


func _physics_process(delta: float) -> void:
	attack_timer -= delta
	if attack_timer <= 0.0:
		attack_timer = ATTACK_INTERVAL
		_shoot_at_player()


func take_damage(amount: int = 1) -> void:
	if amount <= 0 or health <= 0:
		return
	health = maxi(health - amount, 0)
	if health_bar != null:
		health_bar.value = health
	boss_health_changed.emit(health, max_health)
	if health == 0:
		boss_defeated.emit()
		queue_free()
		GameManager.victory()


func _shoot_at_player() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var projectile := PROJECTILE_SCENE.instantiate() as Area2D
	projectile.set("direction", (player.global_position - global_position).normalized())
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position + Vector2(0.0, -8.0)
