extends CanvasLayer
## HUD yang menampilkan status permainan terkini.

@onready var health_label: Label = $Control/HealthLabel
@onready var crystal_label: Label = $Control/CrystalLabel


func _ready() -> void:
	GameManager.health_changed.connect(_on_health_changed)
	GameManager.royal_crystal_collected.connect(_on_royal_crystal_collected)
	GameManager.game_over.connect(_on_game_over)
	GameManager.game_won.connect(_on_game_won)
	_on_health_changed(GameManager.health)
	if GameManager.has_royal_crystal:
		_on_royal_crystal_collected()
	else:
		_set_crystal_not_found()


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
