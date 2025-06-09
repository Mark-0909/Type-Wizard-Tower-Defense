extends Node2D

 # booster 1 = add castle health
 # booster 2 = freeze
 # booster 3 = explosion
@export var game_manager: Node = null

@export var booster_type = 0
var word: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$word.text = word.to_upper()
	# deploy animation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func Match() -> void:
	game_manager.Add_Booster(booster_type)
	queue_free()

func get_word() -> String:
	return word.to_upper()
