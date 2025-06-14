extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Start fully transparent
	modulate.a = 0.0
	# Fade in smoothly
	await fade_in()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_closebtn_mouse_entered() -> void:
	$closebtn.modulate = Color(1.5, .8, .8)


func _on_closebtn_mouse_exited() -> void:
	$closebtn.modulate = Color(1,1,1)


func fade_in() -> void:
	for i in range(15):
		modulate.a = lerp(0.0, 1.0, i / 15.0)
		await get_tree().create_timer(0.02).timeout

func _on_closebtn_pressed() -> void:
	for i in range(15):
		modulate.a = lerp(1.0, 0.0, i / 15.0)
		await get_tree().create_timer(0.02).timeout
	queue_free()
