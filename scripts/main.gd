extends Node2D

# Spawn areas
@onready var spawn_area_1: Marker2D = $"spawn area/Marker2D"
@onready var spawn_area_2: Marker2D = $"spawn area/Marker2D2"
@onready var spawn_area_3: Marker2D = $"spawn area/Marker2D3"
@onready var spawn_area_4: Marker2D = $"spawn area/Marker2D4"
@onready var spawn_area_5: Marker2D = $"spawn area/Marker2D5"
@onready var spawn_area_6: Marker2D = $"spawn area/Marker2D6"
@onready var spawn_area_7: Marker2D = $"spawn area/Marker2D7"
@onready var spawn_area_8: Marker2D = $"spawn area/Marker2D8"
@onready var spawn_area_9: Marker2D = $"spawn area/Marker2D9"

var spawn_areas: Array[Marker2D] = []
var typed_letters: Array = []

var letter_offset := 0  # Start at 0 and increment for each new letter
var letter_spacing := 150  # Space between letters (adjust as needed)
var letter_scale := Vector2(1, 1)  # Adjust to your desired size

var last_spawn_position = 0

var velocity:float = 100.0

# Enemies
const ENEMY_1 = preload("res://nodes/enemy1.tscn")

@onready var game_manager: Node = $GameManager
@onready var typing_container: Control = $Typingcontainer

# Spawn settings
var spawn_timer := 0.0
var spawn_interval := 3.0
var min_spawn_interval := 0.8
var spawn_acceleration := 0.01


func _ready() -> void:
	spawn_areas = [
		spawn_area_1, spawn_area_2, spawn_area_3,
		spawn_area_4, spawn_area_5, spawn_area_6,
		spawn_area_7, spawn_area_8, spawn_area_9
	]


func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_enemy()
		spawn_interval = max(min_spawn_interval, spawn_interval - spawn_acceleration)
		spawn_timer = spawn_interval

	if typed_letters.size() > 0:
		$Castle/Wizard._change_state($Castle/Wizard.State.CHARGING)
	else: 
		$Castle/Wizard._change_state($Castle/Wizard.State.IDLE)
	
	if Input.is_action_just_pressed("Clear"):
		clear_typed_letters()


func spawn_enemy() -> void:
	var enemy = ENEMY_1.instantiate()

	var index := randi() % spawn_areas.size()

	# Prevent spawning twice in a row in the same spot
	while index == last_spawn_position and spawn_areas.size() > 1:
		index = randi() % spawn_areas.size()

	var area = spawn_areas[index]
	last_spawn_position = index

	enemy.global_position = area.global_position

	var word_length = randi_range(4, 10)
	var word_list = game_manager.word_pool.get(word_length, [])
	if word_list.size() > 0:
		enemy.word = word_list.pick_random()
	enemy.velocity = velocity
	add_child(enemy)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var key = event.keycode

		# Backspace support (removes the last letter)
		if key == KEY_BACKSPACE and typed_letters.size() > 0:
			var last_letter_dict = typed_letters.pop_back()
			last_letter_dict.node.queue_free()
			letter_offset -= letter_spacing
			_print_typed_letters()
			return

		# Add letter if valid
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

			# Center the letter in the typing container
			var container_center = typing_container.global_position + typing_container.size / 2.0
			letter_instance.position = container_center - letter_size / 2.0 + Vector2(letter_offset, 0)

			letter_offset += letter_spacing

			# Extract letter from the scene's filename (like 'a' from 'a.tscn')
			var path = letter_scene.resource_path
			var letter_char = path.get_file().get_basename().to_upper()

			typed_letters.append({"node": letter_instance, "char": letter_char})

			_print_typed_letters()
			check_enemy_matches()
	


func _print_typed_letters() -> void:
	var typed_text := ""
	for letter_dict in typed_letters:
		typed_text += letter_dict.char
	print("Typed: ", typed_text)

func check_enemy_matches() -> void:
	var typed_text := ""
	for letter_dict in typed_letters:
		typed_text += letter_dict.char

	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.has_method("get_word") and not enemy.is_on_aim():
			
			if enemy.get_word().to_upper() == typed_text:
				print("Matched enemy with word:", enemy.get_word())
				if $Castle/Wizard.has_method("Fire"):
					$Castle/Wizard.get_node("AnimatedSprite2D").play("attack")
					await get_tree().create_timer(0.2).timeout
					$Castle/Wizard.Fire(enemy)
					
				clear_typed_letters()
				enemy._is_on_aim = true
	



func clear_typed_letters():
	for letter_dict in typed_letters:
		letter_dict.node.queue_free()
	typed_letters.clear()
	letter_offset = 0


func _on_timer_timeout() -> void:
	velocity += 50.0
