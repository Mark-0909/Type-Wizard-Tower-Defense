extends Node2D

# Boss state and movement
var words: Array[String] = []  # Words assigned from the word pool
var current_word_index: int = 0
var velocity: float = 100.0
var is_moving: bool = true
var _is_on_aim: bool = false
var _is_dead: bool = false
var _is_attacking = false

@export var game_manager: Node = null
# Node references
@onready var label = $word
@onready var raycast = $RayCast2D
@onready var sprite = $AnimatedSprite2D

const BOOSTER_1 = preload("res://nodes/booster_1.tscn")
const BOOSTER_2 = preload("res://nodes/booster_2.tscn")
const BOOSTER_3 = preload("res://nodes/booster_3.tscn")
var booster_list = [BOOSTER_1, BOOSTER_2, BOOSTER_3]
# Signal emitted when boss dies
signal boss_died

func _ready() -> void:
	raycast.enabled = true
	_set_word_label()
	


func _process(delta: float) -> void:
	if _is_dead:
		return
	
	if _is_attacking:
		var boss_type = get_groups()
		if "boss1" in boss_type:
			Boss1(true)
		elif "boss2" in boss_type:
			Boss2(true)
		elif "boss3" in boss_type:
			Boss3(true)
		elif "boss4" in boss_type:
			Boss4(true)
	
	if is_moving:
		position.y += velocity * delta

func _set_word_label() -> void:
	if current_word_index < words.size():
		label.text = words[current_word_index].to_upper()
	else:
		label.text = ""

func start_attack_delay() -> void:
	if not _is_dead:
		is_moving = false
		attack()

func attack() -> void:
	if _is_dead:
		return
	sprite.play("attack")
	_is_attacking = true
	
	

func next_phase() -> void:
	current_word_index += 1
	if current_word_index >= words.size():
		die()
	else:
		modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(.2).timeout
		modulate = Color(1, 1, 1)
		await get_tree().create_timer(.2).timeout
		modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(.2).timeout
		modulate = Color(1, 1, 1)
		print("Boss hit! Lives left: ", words.size() - current_word_index)
		sprite.play("hurt")
		_is_on_aim = false
		is_moving = false 
		attack()  
		
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
	sprite.play("attack")
	
	var boss_type = get_groups()
	if "boss1" in boss_type:
		Boss1(false)
	elif "boss2" in boss_type:
		Boss2(false)
	elif "boss3" in boss_type:
		Boss3(false)
	elif "boss4" in boss_type:
		Boss4(false)
	spawn_booster()
	
func spawn_booster() -> void:
	
	var chance = randi() % 100
	if chance >= 50:
		return  
	
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
	booster.booster_type = booster_index + 1  

	get_parent().add_child(booster)  
	booster.global_position = global_position  # Spawns at enemy's position

func is_on_aim() -> bool:
	return _is_on_aim

func get_word() -> String:
	if current_word_index < words.size():
		return words[current_word_index].to_upper()
	return ""

func check_input(input_word: String) -> void:
	if _is_dead:
		return
	
	if input_word.strip_edges().to_upper() == get_word():
		print("Correct word typed!")
		next_phase()
	else:
		print("Incorrect word.")

# BOSS EFFECTS
func Boss1(is_in_effect: bool):
	print("mantis in effect")
	var targets := []
	for node in get_tree().get_nodes_in_group("smallmobs"):
		if is_instance_valid(node) and node not in targets:
			targets.append(node)
	for target in targets:
		if is_in_effect and target.has_method("Boss_1") and not target.has_method("boss1_applied"):
			target.Boss_1()
		elif not is_in_effect and target.has_method("Boss1_End"):
			target.Boss1_End()
		

func Boss2(is_in_effect: bool):
	print("Boss2 (Plant) effect in effect:", is_in_effect)
	var DIRTY = preload("res://assets/dirty.png")
	
	for node in get_tree().get_nodes_in_group("letter"):
		if is_instance_valid(node):
			# First, check if a dirty overlay already exists on the node
			var existing_overlay = node.get_node_or_null("DirtyOverlay")
			
			if is_in_effect:
				if existing_overlay == null:
					var overlay = Sprite2D.new()
					overlay.name = "DirtyOverlay"
					overlay.texture = DIRTY
					overlay.modulate = Color(1, 1, 1, 0.6)  # semi-transparent
					overlay.z_index = 100  # Ensure it's on top
					node.add_child(overlay)
			else:
				if existing_overlay:
					existing_overlay.queue_free()


func Boss3(is_in_effect: bool):
	print("vampire in effect: ", is_in_effect)
	var targets := []
	for node in get_tree().get_nodes_in_group("smallmobs"):
		if is_instance_valid(node) and node not in targets:
			targets.append(node)
	for target in targets:
		if is_in_effect and target.has_method("Boss_3") and not target.has_method("boss3_applied"):
			target.Boss_3()
		elif not is_in_effect and target.has_method("Boss3_End"):
			target.Boss3_End()



func Boss4(is_in_effect: bool):
	var targets := []
	for node in get_tree().get_nodes_in_group("smallmobs"):
		if is_instance_valid(node) and node not in targets:
			targets.append(node)
	for target in targets:
		if is_in_effect and target.has_method("Boss_4") and not target.has_method("boss4_applied"):
			target.Boss_4()
		elif not is_in_effect and target.has_method("Boss4_End"):
			target.Boss4_End()
