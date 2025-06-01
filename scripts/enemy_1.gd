extends Node2D

var word: String = ""
var velocity: float = 100.0  # Pixels per second
var is_moving: bool = true

func _ready() -> void:
	$word.text = word.to_upper()
	$RayCast2D.enabled = true

func _process(delta: float) -> void:
	if is_moving:
		position.y += velocity * delta
		
		if $RayCast2D.is_colliding():
			var collider = $RayCast2D.get_collider()
			if collider is Node and collider.is_in_group("castle"):
				is_moving = false 
				print("Collide with castle")
				# play attack animation
			else:
				is_moving = false 
				# play idle
		else:
			is_moving = true
