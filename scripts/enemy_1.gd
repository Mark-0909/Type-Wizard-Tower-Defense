extends Node2D

var word: String = ""
var velocity: float = 100.0
var is_moving: bool = true
var _is_on_aim: bool = false
var _is_dead: bool = false  # Flag to prevent animation conflicts

func _ready() -> void:
	$word.text = word.to_upper()
	$RayCast2D.enabled = true

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

func attack():
	if _is_dead:
		return  # Don’t attack if dead
	$AnimatedSprite2D.play("attack")
