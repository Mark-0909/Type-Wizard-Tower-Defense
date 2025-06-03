extends Node2D

var word: String = ""
var velocity: float = 100.0
var is_moving: bool = true

func _ready() -> void:
	$word.text = word.to_upper()
	$RayCast2D.enabled = true

func _process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider and (collider.is_in_group("castle") or collider.is_in_group("enemy")):
			is_moving = false
		else:
			is_moving = true  # Not a valid blocker, keep moving
	else:
		is_moving = true  # No collision, keep moving

	if is_moving:
		position.y += velocity * delta

func get_word() -> String:
	return word.to_upper()
