extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func button_flash(button_node: Node) -> void:
	button_node.modulate = Color(0.8, 0.8, 1.8)
	await get_tree().create_timer(0.1).timeout
	button_node.modulate = Color(1, 1, 1)
