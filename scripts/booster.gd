extends Node2D


var float_speed = .5  # Adjust for faster/slower movement
var float_height = .3  # Adjust for higher/lower floating
var time_passed = 0.0   # Tracks time for smooth animation

 # booster 1 = add castle health
 # booster 2 = freeze
 # booster 3 = explosion
@export var game_manager: Node = null

@export var booster_type = 0
var word: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$word.text = word.to_upper()
	$AnimatedSprite2D.play("creation")
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	time_passed += delta * float_speed
	position.y += sin(time_passed) * float_height

	
func Match() -> void:
	game_manager.Add_Booster(booster_type)
	$AnimatedSprite2D.play("removing")
	await get_tree().create_timer(0.5).timeout
	queue_free()

func get_word() -> String:
	return word.to_upper()
