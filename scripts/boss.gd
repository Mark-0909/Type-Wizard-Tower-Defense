extends Node2D

# Boss state and movement
var words: Array[String] = []  # Words assigned from the word pool
var current_word_index: int = 0
var velocity: float = 100.0
var is_moving: bool = true
var _is_on_aim: bool = false
var _is_dead: bool = false

# Node references
@onready var label = $word
@onready var raycast = $RayCast2D
@onready var sprite = $AnimatedSprite2D

# Signal emitted when boss dies
signal boss_died

func _ready() -> void:
	raycast.enabled = true
	start_attack_delay()
	_set_word_label()

func _process(delta: float) -> void:
	if _is_dead:
		return

	if is_moving:
		position.y += velocity * delta

func _set_word_label() -> void:
	if current_word_index < words.size():
		label.text = words[current_word_index].to_upper()
	else:
		label.text = ""

func start_attack_delay() -> void:
	await get_tree().create_timer(8.0).timeout
	if not _is_dead:
		is_moving = false
		attack()

func attack() -> void:
	if _is_dead:
		return
	sprite.play("attack")

func next_phase() -> void:
	current_word_index += 1
	if current_word_index >= words.size():
		die()
	else:
		print("Boss hit! Lives left: ", words.size() - current_word_index)
		sprite.play("hurt")
		_is_on_aim = false
		is_moving = false  # Boss stops moving permanently
		# optionally remove _set_word_label() if boss no longer changes label
		attack()  # Play attack animation forever

		_set_word_label()

func die() -> void:
	_is_dead = true
	is_moving = false
	velocity = 0.0
	await get_tree().create_timer(1.5).timeout
	sprite.stop()
	sprite.play("death")
	await get_tree().create_timer(0.8).timeout
	emit_signal("boss_died")
	queue_free()

func is_on_aim() -> bool:
	return _is_on_aim

func get_word() -> String:
	if current_word_index < words.size():
		return words[current_word_index].to_upper()
	return ""

# 🆕 NEW: Call this function from outside to check if the player typed the correct word
func check_input(input_word: String) -> void:
	if _is_dead:
		return
	
	if input_word.strip_edges().to_upper() == get_word():
		print("Correct word typed!")
		next_phase()
	else:
		print("Incorrect word.")
