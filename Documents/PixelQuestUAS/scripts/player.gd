extends CharacterBody2D
## Kontrol dasar pemain untuk platformer Pixel Quest: Royal Crystal.

const BULLET_SCENE: PackedScene = preload("res://scenes/Bullet.tscn")

signal take_damage(amount: int)
signal collect_crystal(points: int, is_royal: bool)

const SPEED: float = 180.0
const JUMP_VELOCITY: float = -380.0
const MOVE_ACCELERATION: float = 1200.0
const MOVE_DECELERATION: float = 1500.0

@onready var sprite: Sprite2D = get_node_or_null("Sprite2D") as Sprite2D
@onready var color_visual: ColorRect = get_node_or_null("ColorRect") as ColorRect
@onready var camera: Camera2D = get_node_or_null("Camera2D") as Camera2D

var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
var facing_direction: float = 1.0
var shoot_cooldown: float = 0.0
var jumps_used: int = 0
var shake_time_left: float = 0.0
var shake_intensity: float = 0.0


func _ready() -> void:
	add_to_group("player")
	# Snap membantu karakter tetap menempel pada lereng kecil saat bergerak.
	floor_snap_length = 8.0
	floor_max_angle = deg_to_rad(46.0)
	floor_stop_on_slope = true


func _physics_process(delta: float) -> void:
	if is_on_floor():
		jumps_used = 0

	shake_time_left = maxf(shake_time_left - delta, 0.0)
	if camera != null:
		camera.offset = Vector2.ZERO if shake_time_left <= 0.0 else Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
	shoot_cooldown = maxf(shoot_cooldown - delta, 0.0)
	if _shoot_input_pressed() and shoot_cooldown <= 0.0:
		_shoot()
		shoot_cooldown = 0.18

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and jumps_used < 2:
		velocity.y = JUMP_VELOCITY
		jumps_used += 1
		GameManager.play_sfx(&"jump")

	var direction: float = Input.get_axis("ui_left", "ui_right")
	if not is_zero_approx(direction):
		facing_direction = signf(direction)
		velocity.x = move_toward(velocity.x, direction * SPEED, MOVE_ACCELERATION * delta)
		if sprite != null:
			sprite.flip_h = direction < 0.0
		elif color_visual != null:
			color_visual.scale.x = -1.0 if direction < 0.0 else 1.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, MOVE_DECELERATION * delta)

	move_and_slide()


func _shoot_input_pressed() -> bool:
	return (
		Input.is_action_just_pressed("ui_select")
		or Input.is_key_pressed(KEY_J)
		or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	)


func _shoot() -> void:
	screen_shake(0.08, 2.0)
	var bullet := BULLET_SCENE.instantiate() as Area2D
	bullet.set("direction", facing_direction)
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position + Vector2(22.0 * facing_direction, -4.0)
	GameManager.play_sfx(&"shoot")


## Panggil dari area bahaya atau sistem pertarungan.
func receive_damage(amount: int = 10) -> void:
	if amount > 0:
		screen_shake(0.16, 4.0)
		take_damage.emit(amount)


func screen_shake(duration: float, intensity: float) -> void:
	shake_time_left = maxf(shake_time_left, duration)
	shake_intensity = maxf(shake_intensity, intensity)


## Panggil saat pemain menyentuh kristal; tandai kristal utama sebagai royal.
func pickup_crystal(points: int = 1, is_royal: bool = false) -> void:
	collect_crystal.emit(maxi(points, 0), is_royal)
