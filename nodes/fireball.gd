extends Area2D

@export var speed: float = 2000.0
var target: Node2D = null
var is_gone: bool = false

func _ready() -> void:
	$AnimatedSprite2D.play("create")
	await get_tree().create_timer(0.3).timeout
	$AnimatedSprite2D.play("default")
	

func set_target(enemy: Node2D) -> void:
	target = enemy

func _process(delta: float) -> void:
	if is_instance_valid(target):  # Ensure target is not freed
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
	else:
		is_gone = true
		$AnimatedSprite2D.play("gone")
		await get_tree().create_timer(0.3).timeout
		queue_free()
	if is_gone:
		if $AnimatedSprite2D.animation != "gone":
			$AnimatedSprite2D.play("gone")

func _on_body_entered(body: Node2D) -> void:
	if body == target:
		is_gone = true
		$AnimatedSprite2D.play("gone")
		await get_tree().create_timer(0.3).timeout

		# Ensure body is still valid before checking methods
		if is_instance_valid(body) and body.has_method("Dead"):
			body.Dead()
		
		queue_free()
