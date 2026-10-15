extends Control


func _ready() -> void:
	$CenterContainer/VBoxContainer/ReplayButton.pressed.connect(_on_replay_pressed)
	$CenterContainer/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)


func _on_replay_pressed() -> void:
	GameManager.health = GameManager.MAX_HEALTH
	GameManager.score = 0
	GameManager.has_royal_crystal = false
	GameManager.has_won = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
