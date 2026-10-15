extends CanvasLayer
## HUD yang menampilkan status permainan terkini.

@onready var health_label: Label = $Control/HealthLabel
@onready var crystal_label: Label = $Control/CrystalLabel
@onready var boss_health_bar: ProgressBar = $Control/BossHealthBar


func _ready() -> void:
	boss_health_bar.hide()
	var boss := get_tree().get_first_node_in_group("boss")
	if boss != null:
		_connect_boss(boss)
	GameManager.health_changed.connect(_on_health_changed)
	GameManager.royal_crystal_collected.connect(_on_royal_crystal_collected)
	GameManager.game_over.connect(_on_game_over)
	GameManager.game_won.connect(_on_game_won)
	_on_health_changed(GameManager.health)
	if GameManager.has_royal_crystal:
		_on_royal_crystal_collected()
	else:
		_set_crystal_not_found()


func _connect_boss(boss: Node) -> void:
	if boss.has_signal("boss_health_changed"):
		boss.connect("boss_health_changed", Callable(self, "_on_boss_health_changed"))
		boss.connect("boss_defeated", Callable(self, "_on_boss_defeated"))
		_on_boss_health_changed(boss.get("health"), boss.get("max_health"))
		boss_health_bar.show()


func _on_boss_health_changed(current_hp: int, max_hp: int) -> void:
	boss_health_bar.max_value = max_hp
	boss_health_bar.value = current_hp


func _on_boss_defeated() -> void:
	boss_health_bar.hide()


func _on_health_changed(current_health: int) -> void:
	health_label.text = "Health: %d" % current_health


func _set_crystal_not_found() -> void:
	crystal_label.text = "Royal Crystal: Belum Ditemukan"


func _on_royal_crystal_collected() -> void:
	crystal_label.text = "Royal Crystal: Ditemukan!"


func _on_game_over() -> void:
	health_label.text = "Game Over"


func _on_game_won() -> void:
	crystal_label.text = "Shadow Forest: Terselesaikan!"
