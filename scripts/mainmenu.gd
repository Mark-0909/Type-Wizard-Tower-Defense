extends Node2D

const CONTROLS = preload("res://nodes/controls.tscn")
const MAIN = preload("res://nodes/main.tscn")
const SETTINGS = preload("res://nodes/settings.tscn")

var on_mute = false

func _ready() -> void:
	modulate.a = 0.0
	await fade_in()

func _process(delta: float) -> void:
	pass

func fade_out() -> void:
	for i in range(20):
		modulate.a = lerp(modulate.a, 0.0, 0.2)
		await get_tree().create_timer(0.02).timeout

func fade_in() -> void:
	for i in range(20):
		modulate.a = lerp(modulate.a, 1.0, 0.2)
		await get_tree().create_timer(0.02).timeout

func button_flash(button_node: Node) -> void:
	button_node.modulate = Color(0.8, 0.8, 1.8)
	await get_tree().create_timer(0.1).timeout
	button_node.modulate = Color(1, 1, 1)

func _on_start_pressed() -> void:
	await button_flash($start)
	$click.play()
	await fade_out()

	if MAIN:
		var new_scene = MAIN.instantiate()
		get_tree().root.add_child(new_scene)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = new_scene
	else:
		print("Error: MAIN scene failed to load.")

func _on_mechanics_pressed() -> void:
	await button_flash($mechanics)
	$click.play()
	var controls = CONTROLS.instantiate()
	add_child(controls)

func _on_settings_pressed() -> void:
	await button_flash($settings)
	$click.play()
	var settings = SETTINGS.instantiate()
	settings.music_player = $BG  # Ensure $BG is an AudioStreamPlayer node
	add_child(settings)

# HOVER SCALE HANDLERS



func _on_start_mouse_entered() -> void:
	$start.scale += Vector2(.1, .1)
	$hover.play()
	
func _on_start_mouse_exited() -> void:
	$start.scale -= Vector2(.1, .1)
	$hover.play()

func _on_mechanics_mouse_entered() -> void:
	$mechanics.scale += Vector2(.1, .1)
	$hover.play()

func _on_mechanics_mouse_exited() -> void:
	$mechanics.scale -= Vector2(.1, .1)
	$hover.play()

func _on_settings_mouse_entered() -> void:
	$settings.scale += Vector2(.1, .1)
	$hover.play()

func _on_settings_mouse_exited() -> void:
	$settings.scale -= Vector2(.1, .1)
	$hover.play()
