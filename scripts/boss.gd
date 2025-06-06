extends Node2D

var word: String = ""
var velocity: float = 100.0
var is_moving: bool = true
var _is_on_aim: bool = false
var _is_dead: bool = false

@onready var label = $word
@onready var raycast = $RayCast2D
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	label.text = word.to_upper()
	raycast.enabled = true

	# Start 5-second countdown to attack
	start_attack_delay()

func _process(delta: float) -> void:
	if _is_dead:
		return

	if is_moving:
		position.y += velocity * delta

func start_attack_delay():
	await get_tree().create_timer(5.0).timeout
	if not _is_dead:
		is_moving = false
		attack()

func attack():
	if _is_dead:
		return
	sprite.play("attack")

func Dead():
	if _is_dead:
		return
	_is_dead = true
	is_moving = false
	velocity = 0.0
	sprite.stop()
	sprite.play("death")
	await get_tree().create_timer(0.8).timeout
	queue_free()

func is_on_aim() -> bool:
	return _is_on_aim

func get_word() -> String:
	return word.to_upper()
