extends Node2D

# Define states
enum State {
	IDLE,
	CHARGING,
	FIRE
}

var current_state: State = State.IDLE

func _ready() -> void:
	_set_animation(current_state)

func _process(delta: float) -> void:
	pass

func _change_state(new_state: State) -> void:
	if current_state != new_state:
		current_state = new_state
		_set_animation(current_state)

func _set_animation(state: State) -> void:
	match state:
		State.IDLE:
			$AnimatedSprite2D.play("default")
		State.CHARGING:
			$AnimatedSprite2D.play("charging")
		State.FIRE:
			$AnimatedSprite2D.play("fire")
			await get_tree().create_timer(0.5).timeout
