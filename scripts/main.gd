extends Node2D

# Spawn areas
@onready var spawn_area_1: Marker2D = $"spawn area/Marker2D"
@onready var spawn_area_2: Marker2D = $"spawn area/Marker2D2"
@onready var spawn_area_3: Marker2D = $"spawn area/Marker2D3"
@onready var spawn_area_4: Marker2D = $"spawn area/Marker2D4"
@onready var spawn_area_5: Marker2D = $"spawn area/Marker2D5" # Boss area
@onready var spawn_area_6: Marker2D = $"spawn area/Marker2D6"
@onready var spawn_area_7: Marker2D = $"spawn area/Marker2D7"
@onready var spawn_area_8: Marker2D = $"spawn area/Marker2D8"
@onready var spawn_area_9: Marker2D = $"spawn area/Marker2D9"

var spawn_areas: Array[Marker2D] = []
var typed_letters: Array = []
var letter_offset := 0
var letter_spacing := 150
var letter_scale := Vector2(1, 1)
var last_spawn_position = 0
var velocity: float = 100.0

# Enemies
const ENEMY_1 = preload("res://nodes/enemy1.tscn")
const ENEMY_2 = preload("res://nodes/enemy2.tscn")
const ENEMY_3 = preload("res://nodes/enemy3.tscn")
const ENEMY_4 = preload("res://nodes/enemy4.tscn")
const ENEMY_5 = preload("res://nodes/enemy5.tscn")
const ENEMY_6 = preload("res://nodes/enemy6.tscn")
const ENEMY_7 = preload("res://nodes/enemy7.tscn")

# Booster 


# Bosses
const BOSS_1 = preload("res://nodes/boss1.tscn")
const BOSS_2 = preload("res://nodes/boss2.tscn")
const BOSS_3 = preload("res://nodes/boss3.tscn")
const BOSS_4 = preload("res://nodes/boss4.tscn")
var boss_list = [BOSS_1, BOSS_2, BOSS_3, BOSS_4]
var boss_spawned := false
var boss_killed := true
var current_boss = null

# Spawn settings
var spawn_timer := 0.0
var spawn_interval := 3.0
var min_spawn_interval := 0.8
var spawn_acceleration := 0.01
var stop_spawning := false

@onready var game_manager: Node = $GameManager
@onready var typing_container: Control = $Typingcontainer

func _ready() -> void:
	spawn_areas = [
		spawn_area_1, spawn_area_2, spawn_area_3,
		spawn_area_4, spawn_area_5, spawn_area_6,
		spawn_area_7, spawn_area_8, spawn_area_9
	]
	start_boss_cycle()
	$Castle.modulate = Color(1,1,1,0)

func _process(delta: float) -> void:
	if not stop_spawning:
		spawn_timer -= delta
		if spawn_timer <= 0:
			spawn_enemy()
			spawn_interval = max(min_spawn_interval, spawn_interval - spawn_acceleration)
			spawn_timer = spawn_interval

	if typed_letters.size() > 0:
		$Wizard._change_state($Wizard.State.CHARGING)
	else:
		$Wizard._change_state($Wizard.State.IDLE)

	if Input.is_action_just_pressed("Clear"):
		clear_typed_letters()
	
	if Input.is_action_just_pressed("explosion"):
		game_manager.booster3()
	if Input.is_action_just_pressed("frozen"):
		game_manager.booster2()
	if Input.is_action_just_pressed("health"):
		game_manager.booster1()
func spawn_enemy() -> void:
	var word_length = randi_range(4, 11)
	var word_list = game_manager.word_pool.get(word_length, [])
	if word_list.size() == 0:
		return

	var word = word_list.pick_random()
	var enemy_scene = enemy_types_by_length.get(word_length, ENEMY_1)
	var enemy = enemy_scene.instantiate()
	enemy.word = word
	enemy.game_manager = game_manager
	enemy.velocity = velocity

	var available_areas = get_valid_spawn_areas()
	if available_areas.is_empty():
		return

	var index := randi() % available_areas.size()
	var area = available_areas[index]
	last_spawn_position = index
	enemy.global_position = area.global_position
	add_child(enemy)



func get_valid_spawn_areas() -> Array:
	var areas = spawn_areas.duplicate()
	if boss_spawned:
		areas.erase(spawn_area_4)
		areas.erase(spawn_area_5)
		areas.erase(spawn_area_6)
	return areas

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var key = event.keycode
		if key == KEY_BACKSPACE and typed_letters.size() > 0:
			var last_letter_dict = typed_letters.pop_back()
			last_letter_dict.node.queue_free()
			letter_offset -= letter_spacing
			_print_typed_letters()
			return

		if game_manager.letter_scenes.has(key):
			var letter_scene = game_manager.letter_scenes[key]
			var letter_instance = letter_scene.instantiate()
			letter_instance.scale = letter_scale
			get_tree().current_scene.add_child(letter_instance)

			var letter_size = Vector2.ZERO
			if letter_instance.has_node("Sprite2D"):
				var sprite = letter_instance.get_node("Sprite2D")
				letter_size = sprite.texture.get_size() * sprite.scale * letter_instance.scale
			elif letter_instance.has_node("Label"):
				var label = letter_instance.get_node("Label")
				letter_size = label.get_minimum_size() * letter_instance.scale

			var container_center = typing_container.global_position + typing_container.size / 2.0
			letter_instance.position = container_center - letter_size / 2.0 + Vector2(letter_offset, 0)
			letter_offset += letter_spacing

			var path = letter_scene.resource_path
			var letter_char = path.get_file().get_basename().to_upper()
			typed_letters.append({"node": letter_instance, "char": letter_char})

			_print_typed_letters()
			check_enemy_matches()
			check_booster_matches()

func _print_typed_letters() -> void:
	var typed_text := ""
	for letter_dict in typed_letters:
		typed_text += letter_dict.char
	print("Typed: ", typed_text)


func check_booster_matches() -> void:
	var typed_text := ""
	for letter_dict in typed_letters:
		if "char" in letter_dict:
			typed_text += str(letter_dict.char)

	for booster in get_tree().get_nodes_in_group("booster"):
		if not is_instance_valid(booster):
			continue
		if not booster.has_method("get_word") or not booster.has_method("Match"):
			continue

		if booster.get_word().to_upper() == typed_text.to_upper():
			print("Matched booster with word:", booster.get_word())
			clear_typed_letters()
			booster.Match()



func check_enemy_matches() -> void:
	var typed_text := ""
	for letter_dict in typed_letters:
		typed_text += letter_dict.char

	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy):
			continue
		if not enemy.has_method("get_word") or enemy.is_on_aim():
			continue

		if enemy.get_word().to_upper() == typed_text:
			print("Matched enemy with word:", enemy.get_word())

			var can_fire := true

			if enemy.is_in_group("boss"):
				# Check if this word is the FINAL word
				if not enemy.has_method("is_final_phase") or not enemy.is_final_phase():
					can_fire = false
					print("⛔ Boss not in final phase, cannot fire.")
				else:
					print("🔥 Boss in final phase, fire allowed.")

			if can_fire and $Wizard.has_method("Fire"):
				$Wizard.get_node("AnimatedSprite2D").play("attack")
				await get_tree().create_timer(0.2).timeout
				$Wizard.Fire(enemy) 

			clear_typed_letters()

			if enemy.has_method("next_phase"):
				enemy.next_phase()  # Move boss to next phase if not dead
			else:
				enemy._is_on_aim = true  # Prevent double targeting


func clear_typed_letters():
	for letter_dict in typed_letters:
		letter_dict.node.queue_free()
	typed_letters.clear()
	letter_offset = 0

func _on_timer_timeout() -> void:
	velocity += 50.0

func start_boss_cycle() -> void:
	await get_tree().create_timer(15).timeout
	spawn_boss()

func spawn_boss() -> void:
	if boss_spawned:
		return

	var boss_scene = boss_list.pick_random()
	current_boss = boss_scene.instantiate()

	var chosen_words: Array[String] = []
	while chosen_words.size() < 4:
		var length = randi_range(4, 11)
		var word_list = game_manager.word_pool.get(length, [])
		if word_list.size() == 0:
			continue
		var word = word_list.pick_random()
		if word not in chosen_words:
			chosen_words.append(word)

	current_boss.words = chosen_words
	current_boss.game_manager = game_manager
	current_boss.global_position = spawn_area_5.global_position
	current_boss.boss_died.connect(_on_boss_died)
	add_child(current_boss)
	boss_spawned = true
	boss_killed = false
	print("⚠️ Boss has spawned with words: ", chosen_words)

	await get_tree().create_timer(15).timeout
	stop_spawning = true

func _on_boss_died() -> void:
	print("✅ Boss defeated. Resuming enemy spawn.")
	stop_spawning = false
	boss_killed = true
	boss_spawned = false
	current_boss = null
	await get_tree().create_timer(15).timeout
	spawn_boss()

var enemy_types_by_length := {
	4: ENEMY_1,
	5: ENEMY_2,
	6: ENEMY_2,
	7: ENEMY_3,
	8: ENEMY_4,
	9: ENEMY_5,
	10: ENEMY_6,
	11: ENEMY_7
}
