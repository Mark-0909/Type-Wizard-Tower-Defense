extends Area2D

@export var speed: float = 100.0
var target: Node2D = null

func _ready() -> void:
	$AnimatedSprite2D.play("default")


func set_target(enemy: Node2D) -> void:
	target = enemy

func _process(delta: float) -> void:
	if target:
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(.5).timeout
	
	if body == target:
		body.Dead()
		queue_free()
