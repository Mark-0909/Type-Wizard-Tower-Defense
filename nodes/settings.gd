extends Control

var music_player: AudioStreamPlayer = null
var game_manager: Node = null


func _ready() -> void:
	if music_player:
		# Convert dB to linear (0.0–1.0) then scale to 0–100 for slider
		var linear_volume = db_to_linear(music_player.volume_db)
		$Volume.value = clamp(linear_volume * 100.0, 0.0, 100.0)
	else:
		$Volume.value = 50  # Default fallback

	modulate.a = 0.0
	await fade_in()

func _process(delta: float) -> void:
	print("Volume: ", game_manager.volume)

func fade_in() -> void:
	for i in range(15):
		modulate.a = lerp(0.0, 1.0, i / 15.0)
		await get_tree().create_timer(0.02).timeout

func _on_closebtn_2_pressed() -> void:
	$click.play()
	for i in range(15):
		modulate.a = lerp(1.0, 0.0, i / 15.0)
		await get_tree().create_timer(0.02).timeout
	queue_free()

func _on_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

func _on_volume_value_changed(value: float) -> void:
	if music_player:
		var normalized = clamp(value / 100.0, 0.001, 1.0)
		music_player.volume_db = linear_to_db(normalized)
		
	if game_manager:
		game_manager.volume = value




func _on_closebtn_2_mouse_entered() -> void:
	$hover.play()
	$closebtn2.scale += Vector2(.1, .1)

func _on_closebtn_2_mouse_exited() -> void:
	$hover.play()
	$closebtn2.scale -= Vector2(.1, .1)
