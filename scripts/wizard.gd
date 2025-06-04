extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
const FIREBALL = preload("res://nodes/fireball.tscn")

# Define states
enum State {
	IDLE,
	CHARGING,
}

var current_state: State = State.IDLE

func _ready() -> void:
	_set_animation(current_state)


func _change_state(new_state: State) -> void:
	if current_state != new_state:
		current_state = new_state
		_set_animation(current_state)
		print("Changing state to:", new_state)

func _set_animation(state: State) -> void:
	match state:
		State.IDLE:
			$AnimatedSprite2D.play("default")
		State.CHARGING:
			$AnimatedSprite2D.play("charging")

func Fire(enemy: Node2D):
	print("Attack animation playing")
	await get_tree().create_timer(0.5).timeout
	var fireball = FIREBALL.instantiate()
	
	if fireball.has_method("set_target"):
		fireball.set_target(enemy)
	else:
		fireball.target = enemy  

	get_parent().add_child(fireball)
	fireball.scale = Vector2(.4,5)
	fireball.z_index = 1000
	fireball.global_position = marker_2d.global_position

	await get_tree().create_timer(1.0).timeout

	_change_state(State.IDLE)
