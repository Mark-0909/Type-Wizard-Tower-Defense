extends Node2D

var word: String = ""
var velocity: float = 100.0  # Pixels per second

func _ready() -> void:
	$word.text = word.to_upper()

func _process(delta: float) -> void:
	position.y += velocity * delta
