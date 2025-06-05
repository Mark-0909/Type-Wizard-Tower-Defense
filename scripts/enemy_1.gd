extends Node2D

var word: String = ""
var velocity: float = 100.0
var is_moving: bool = true

var _is_on_aim: bool = false

func _ready() -> void:
	var label = $word
	label.text = word.to_upper()
	$RayCast2D.enabled = true
	

func is_on_aim() -> bool:
	return _is_on_aim

func _process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider and (collider.is_in_group("castle") or collider.is_in_group("enemy")):
			is_moving = false
			if collider and collider.is_in_group("castle"):
				attack()
			else:
				$AnimatedSprite2D.play("idle")
		else:
			is_moving = true  # Not a valid blocker, keep moving
	else:
		is_moving = true  # No collision, keep moving

	if is_moving:
		position.y += velocity * delta

func get_word() -> String:
	return word.to_upper()

func Dead():
	is_moving = false
	velocity = 0.0  # Correct type
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(.8).timeout
	queue_free()


func attack():
	$AnimatedSprite2D.play("attack")
	
