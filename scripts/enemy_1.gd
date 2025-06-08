extends Node2D

var word: String = ""
var velocity: float = 100.0
var is_moving: bool = true
var _is_on_aim: bool = false
var _is_dead: bool = false 
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

func spawn_booster() -> void:
	var chance = randi() % 100
	if chance >= 10:
		return  # 90% chance to skip spawning, 25% chance to proceed

	var word_length = 4
	var word_list = game_manager.word_pool.get(word_length, [])
	if word_list.size() == 0:
		return

	var word = word_list.pick_random()

	# Pick a random booster and determine its type
	var booster_index = randi() % booster_list.size()
	var booster_scene = booster_list[booster_index]
	var booster = booster_scene.instantiate()

	booster.word = word
	booster.game_manager = game_manager
	booster.booster_type = booster_index + 1  # index 0 = type 1, index 1 = type 2, etc.

	get_parent().add_child(booster)  # Adds booster to the world scene
	booster.global_position = global_position  # Spawns at enemy's position


func is_on_aim() -> bool:
	return _is_on_aim

func _process(delta: float) -> void:
	if _is_dead:
		return  # Skip movement and collision if already dead

	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider and (collider.is_in_group("castle") or collider.is_in_group("enemy")):
			is_moving = false
			if collider.is_in_group("castle"):
				attack()
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
		return  # Already dying
	_is_dead = true
	is_moving = false
	velocity = 0.0
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(0.8).timeout
	queue_free()
	spawn_booster()

func attack():
	if _is_dead:
		return  # Don’t attack if dead
	$AnimatedSprite2D.play("attack")

# BOSS EFFECTS

func Boss_1():
	if not boss1_applied:
		boss1_applied = true
		fade_loop_active = true
		start_fade_loop()

func start_fade_loop() -> void:
	if not is_instance_valid(self):
		return

	tween = create_tween()
	tween.set_loops()  # Infinite looping tween

	while fade_loop_active:
		tween.tween_property(self, "modulate:a", 0.0, 0.5)  # Fade out
		tween.tween_interval(1.0)  # Stay invisible
		tween.tween_property(self, "modulate:a", 1.0, 0.5)  # Fade in
		await tween.finished  # Wait before looping


func Boss1_End():
	boss1_applied = false
	fade_loop_active = false
	if tween:
		tween.kill()
	modulate.a = 1.0  # Reset to fully visiblese 

func Boss_3():
	if not boss3_applied:
		velocity += 100.0
		modulate = Color(1, 0.5, 0.5)
		boss3_applied = true  
func Boss3_End():
	if boss3_applied:
		velocity -= 100.0
		modulate = Color(1, 1, 1)
		boss3_applied = false 

func Boss_4():
	if not boss4_applied:
		var should_apply = randi() % 2 
		if should_apply == 0:
			print("Applying blur effect (passed 50% check)")
			$word.modulate = Color(1, 1, 1, 0.2) 
			boss4_applied = true

func Boss4_End():
	if boss4_applied:
		print("Removing Boss4 blur effect")
		$word.modulate = Color(1, 1, 1, 1)
		boss4_applied = false
