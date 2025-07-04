extends Node2D

var word: String = ""
var velocity: float = 100.0
var delta_data: float = 0.0
var is_moving: bool = true
var _is_on_aim: bool = false
var _is_dead: bool = false
var _is_frozen: bool = false

var _can_attack: bool = true
@export var attack_cooldown: float = 1.5  # cooldown in seconds


@export var game_manager: Node = null

var boss1_applied = false
var fade_loop_active = false
var tween: Tween

const BOOSTER_1 = preload("res://nodes/booster_1.tscn")
const BOOSTER_2 = preload("res://nodes/booster_2.tscn")
const BOOSTER_3 = preload("res://nodes/booster_3.tscn")
var booster_list = [BOOSTER_1, BOOSTER_2, BOOSTER_3]

var boss3_applied = false
var boss4_applied = false

func _ready() -> void:
	$word.text = word.to_upper()
	$RayCast2D.enabled = true
	$frozen.modulate = Color(1, 1, 1, 0)  # Initially hidden

func _process(delta: float) -> void:
	delta_data = delta

	if _is_dead or _is_frozen:
		return  # Skip movement during death or frozen

	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider and (collider.is_in_group("castle") or collider.is_in_group("enemy")):
			is_moving = false
			if collider.is_in_group("castle"):
				attack()
				await get_tree().create_timer(1).timeout
			else:
				$AnimatedSprite2D.play("idle")
		else:
			is_moving = true
	else:
		is_moving = true

	if is_moving:
		position.y += velocity * delta

func get_word() -> String:
	return word.to_upper()

func Dead():
	if _is_dead:
		return
	_is_dead = true
	is_moving = false
	velocity = 0.0
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(0.8).timeout
	queue_free()
	spawn_booster()

func attack():
	if _is_dead or not _can_attack:
		return

	$AnimatedSprite2D.play("attack")
	game_manager.Minus_Health(2)
	_can_attack = false
	attack_cooldown_timer()

func attack_cooldown_timer():
	await get_tree().create_timer(attack_cooldown).timeout
	_can_attack = true

	

func is_on_aim() -> bool:
	return _is_on_aim

# === Booster Spawn ===
func spawn_booster() -> void:
	var chance = randi() % 100
	if chance >= 10:
		return

	var word_length = 4
	var word_list = game_manager.word_pool.get(word_length, [])
	if word_list.is_empty():
		return

	var word = word_list.pick_random()
	var booster_index = randi() % booster_list.size()
	var booster_scene = booster_list[booster_index]
	var booster = booster_scene.instantiate()

	booster.word = word
	booster.game_manager = game_manager
	booster.booster_type = booster_index + 1

	get_parent().add_child(booster)
	booster.global_position = global_position

# === Frozen Effect ===
func frozen_apply() -> void:
	if _is_frozen:
		return

	_is_frozen = true
	is_moving = false

	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.modulate = Color(0.5, 0.8, 1.2, 1)

	$frozen.modulate = Color(1, 1, 1, 1)  
	$frozen.play("freeze")

	await get_tree().create_timer(5).timeout
	frozen_remove()

func frozen_remove() -> void:
	_is_frozen = false
	is_moving = true

	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	$frozen.play("default")  # Stop freeze animation
	$frozen.modulate = Color(1, 1, 1, 0)  # Hide frozen overlay

# === Boss Effects ===
func Boss_1():
	if boss1_applied:
		return
	boss1_applied = true
	fade_loop_active = true
	start_fade_loop()

func start_fade_loop() -> void:
	if not is_instance_valid(self):
		return

	tween = create_tween()
	tween.set_loops()

	while fade_loop_active:
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		tween.tween_interval(1.0)
		tween.tween_property(self, "modulate:a", 1.0, 0.5)
		await tween.finished

func Boss1_End():
	boss1_applied = false
	fade_loop_active = false
	if tween:
		tween.kill()
	modulate.a = 1.0

func Boss_3():
	if boss3_applied:
		return
	velocity += 100.0
	$AnimatedSprite2D.modulate = Color(1, 0.5, 0.5)
	boss3_applied = true

func Boss3_End():
	if not boss3_applied:
		return
	velocity -= 100.0
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
	boss3_applied = false

func Boss_4():
	if boss4_applied:
		return
	if randi() % 2 == 0:
		print("Applying blur effect (passed 50% check)")
		$word.modulate = Color(1, 1, 1, 0.2)
		boss4_applied = true

func Boss4_End():
	if boss4_applied:
		print("Removing Boss4 blur effect")
		$word.modulate = Color(1, 1, 1, 1)
		boss4_applied = false
