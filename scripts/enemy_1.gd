extends Node2D

var word: String = ""
var velocity: float = 50.0
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
	$frozen.modulate = Color(1, 1, 1, 0)  

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
	
	if boss1_applied:
		Boss1_End()
	elif boss3_applied:
		Boss3_End()
	elif boss4_applied:
		Boss4_End()
		
	queue_free()
	spawn_booster()

func attack():
	if _is_dead or not _can_attack:
		return

	$AnimatedSprite2D.play("attack")
	game_manager.Minus_Health(1)
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

	# Randomly pick from 1 to 4
	var anim_id := str(randi() % 4 + 1)
	var steady_id := anim_id + anim_id  # e.g. "1" => "11"

	$frozen.play(anim_id)
	await get_tree().create_timer(0.5).timeout
	$frozen.play(steady_id)
	await get_tree().create_timer(5).timeout
	frozen_remove()


func frozen_remove() -> void:
	_is_frozen = false
	is_moving = true

	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	$frozen.play("default")  
	if boss3_applied:
		$AnimatedSprite2D.modulate = Color(1, 0.5, 0.5)
	$frozen.modulate = Color(1, 1, 1, 0)  # Hide frozen overlay

# === Boss Effects ===
func Boss_1() -> void:
	if boss1_applied:
		return
	boss1_applied = true
	fade_loop_active = true
	_start_fade_loop()

func _start_fade_loop() -> void:
	if not is_instance_valid(self):
		return
	
	async_fade()  # Kick off the async loop

func async_fade() -> void:
	await get_tree().process_frame  # Small delay to let things settle

	while fade_loop_active:
		tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		await tween.finished

		if not fade_loop_active:
			break

		tween = create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 0.5)
		await tween.finished
		
func Boss1_End() -> void:
	if not boss1_applied:
		return

	boss1_applied = false
	fade_loop_active = false

	if tween:
		tween.kill()  # Stop ongoing tween if any

	modulate = Color(modulate.r, modulate.g, modulate.b, 1.0)

func Boss_3() -> void:
	if boss3_applied:
		return
	boss3_applied = true
	velocity += 100.0
	$AnimatedSprite2D.modulate = Color(1, 0.5, 0.5)

func Boss3_End() -> void:
	if not boss3_applied:
		return
	boss3_applied = false
	velocity -= 100.0
	$AnimatedSprite2D.modulate = Color(1, 1, 1)

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
