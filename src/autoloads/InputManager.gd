# InputManager.gd
extends Node

@export var joystick_vector := Vector2.ZERO  # Set by mobile UI if used

func get_move_input() -> Vector2:
	var input_vector = Vector2.ZERO

	# Keyboard input
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	# Add joystick if non-zero
	if joystick_vector.length_squared() > 0.01:
		input_vector = joystick_vector

	return input_vector.normalized()
