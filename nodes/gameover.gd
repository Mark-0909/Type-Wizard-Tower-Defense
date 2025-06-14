extends Control

const MAIN = preload("res://nodes/main.tscn")
const MAINMENU = preload("res://nodes/mainmenu.tscn")

var score: int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$score.text = str(score)

# Called externally to set score
func set_score(value: int) -> void:
	score = value
	$score.text = str(score)

# Hover Effects
func _on_mainmenu_mouse_entered() -> void:
	$hover.play()
	$mainmenu.scale += Vector2(.1, .1)

func _on_mainmenu_mouse_exited() -> void:
	$hover.play()
	$mainmenu.scale -= Vector2(.1, .1)

func _on_restart_mouse_entered() -> void:
	$hover.play()
	$restart.scale += Vector2(.1, .1)

func _on_restart_mouse_exited() -> void:
	$hover.play()
	$restart.scale -= Vector2(.1, .1)

# Button Actions (with working scene switch)
func _on_mainmenu_pressed() -> void:
	$click.play()
	get_tree().create_timer(0.2).timeout.connect(_go_main_menu)

func _on_restart_pressed() -> void:
	$click.play()
	get_tree().create_timer(0.2).timeout.connect(_go_restart)

func _go_main_menu() -> void:
	get_tree().change_scene_to_packed(MAINMENU)

func _go_restart() -> void:
	get_tree().change_scene_to_packed(MAIN)
