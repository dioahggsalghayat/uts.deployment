extends Node
## Autoload untuk menyimpan status permainan lintas scene.

signal health_changed(current_health: int)
signal score_changed(current_score: int)
signal royal_crystal_collected
signal game_over
signal game_won

const MAX_HEALTH: int = 100

var health: int = 100
var score: int = 0
var has_royal_crystal: bool = false
var has_won: bool = false
var _bgm_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
var _sfx_streams: Dictionary = {}
var _ambient_bgm: AudioStreamWAV
var _next_sfx_player: int = 0


func _ready() -> void:
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.name = "BGMPlayer"
	_bgm_player.volume_db = -13.0
	add_child(_bgm_player)

	for index in range(6):
		var player := AudioStreamPlayer.new()
		player.name = "SFXPlayer%d" % index
		player.volume_db = -3.0
		add_child(player)
		_sfx_players.append(player)

	_sfx_streams[&"jump"] = _make_tone(340.0, 680.0, 0.13, 0.28)
	_sfx_streams[&"shoot"] = _make_tone(980.0, 420.0, 0.09, 0.25)
	_sfx_streams[&"crystal"] = _make_tone(520.0, 1040.0, 0.38, 0.3)
	_sfx_streams[&"damage"] = _make_tone(210.0, 85.0, 0.24, 0.36)
	_sfx_streams[&"enemy_hit"] = _make_tone(760.0, 260.0, 0.12, 0.25)

	_ambient_bgm = _make_ambient_bgm()
	play_bgm(_ambient_bgm)


## Memutar stream BGM dan mengganti musik yang sedang berjalan.
func play_bgm(stream: AudioStream) -> void:
	if _bgm_player == null or stream == null:
		return
	if _bgm_player.stream == stream and _bgm_player.playing:
		return
	_bgm_player.stop()
	_bgm_player.stream = stream
	_bgm_player.play()


## Memutar SFX bernama pada channel audio yang tersedia.
func play_sfx(sound_name: StringName) -> void:
	if _sfx_players.is_empty() or not _sfx_streams.has(sound_name):
		return

	var player: AudioStreamPlayer = _sfx_players[_next_sfx_player]
	_next_sfx_player = (_next_sfx_player + 1) % _sfx_players.size()
	player.stream = _sfx_streams[sound_name]
	player.play()


func _make_tone(start_frequency: float, end_frequency: float, duration: float, amplitude: float) -> AudioStreamWAV:
	const SAMPLE_RATE: int = 22050
	var frame_count: int = int(SAMPLE_RATE * duration)
	var samples := PackedByteArray()
	samples.resize(frame_count * 2)
	for frame in range(frame_count):
		var time := float(frame) / SAMPLE_RATE
		var progress := float(frame) / frame_count
		var frequency := lerpf(start_frequency, end_frequency, progress)
		var envelope := minf(minf(time / 0.008, 1.0), maxf((duration - time) / 0.035, 0.0))
		var value := sin(TAU * frequency * time) * amplitude * envelope
		samples.encode_s16(frame * 2, int(value * 32767.0))

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.data = samples
	return stream


func _make_ambient_bgm() -> AudioStreamWAV:
	const SAMPLE_RATE: int = 22050
	const DURATION: float = 8.0
	var frame_count: int = int(SAMPLE_RATE * DURATION)
	var samples := PackedByteArray()
	samples.resize(frame_count * 2)
	for frame in range(frame_count):
		var time := float(frame) / SAMPLE_RATE
		var fade := minf(minf(time / 0.12, 1.0), maxf((DURATION - time) / 0.12, 0.0))
		var swell := 0.72 + 0.28 * sin(TAU * time / DURATION)
		var value := (
			sin(TAU * 110.0 * time) * 0.13
			+ sin(TAU * 164.81 * time) * 0.075
			+ sin(TAU * 220.0 * time) * 0.04
		) * swell * fade
		samples.encode_s16(frame * 2, int(value * 32767.0))

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.data = samples
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_end = frame_count
	return stream


func take_damage(amount: int = 10) -> void:
	if amount <= 0 or health <= 0:
		return

	play_sfx(&"damage")
	var player := get_tree().get_first_node_in_group("player")
	if player != null and player.has_method("screen_shake"):
		player.screen_shake(0.16, 4.0)
	health = maxi(health - amount, 0)
	health_changed.emit(health)
	if health == 0:
		game_over.emit()
		print("Game Over")
		await get_tree().create_timer(1.5).timeout
		reload_scene()


func heal_player(amount: int) -> void:
	if amount <= 0 or health <= 0:
		return
	health = mini(health + amount, MAX_HEALTH)
	health_changed.emit(health)


func victory() -> void:
	if has_won:
		return
	has_won = true
	game_won.emit()
	get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")


func collect_crystal(points: int = 1, is_royal: bool = false) -> void:
	if points > 0:
		score += points
		score_changed.emit(score)

	var current_scene_path: String = get_tree().current_scene.scene_file_path
	if current_scene_path == "res://scenes/Level2.tscn":
		if not has_won:
			has_won = true
			game_won.emit()
			print("Kemenangan! Shadow Forest telah diselesaikan.")
		return

	if is_royal and not has_royal_crystal:
		play_sfx(&"crystal")
		has_royal_crystal = true
		royal_crystal_collected.emit()
		print("Royal Crystal ditemukan. Perjalanan berlanjut ke Shadow Forest...")
		if current_scene_path == "res://scenes/Level1.tscn":
			await get_tree().create_timer(1.0).timeout
			get_tree().change_scene_to_file("res://scenes/Level2.tscn")


func reload_scene() -> void:
	# Memulai ulang run saat ini setelah karakter tumbang.
	health = MAX_HEALTH
	score = 0
	has_royal_crystal = false
	has_won = false
	get_tree().reload_current_scene()
