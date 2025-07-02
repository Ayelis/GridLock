#/src/autoloads/InputManager.gd
extends Node

@export var joystick_vector := Vector2.ZERO  # Set by mobile UI if used

const PING_PATHS = {
	"ping_1": "res://resources/audio/pings/rally_help.ogg",
	"ping_2": "res://resources/audio/pings/attack_info.ogg",
	"ping_3": "res://resources/audio/pings/danger_warded.ogg",
	"ping_4": "res://resources/audio/pings/defend_retreat.ogg",
	"ping_5": "res://resources/audio/pings/enemymissing.ogg",
	"ping_6": "res://resources/audio/pings/omw_ultsoon.ogg",
}
var PINGS = {}

func _ready():
	for action in PING_PATHS.keys():
		PINGS[action] = load(PING_PATHS[action])  # preload() not allowed dynamically

func get_move_input() -> Vector2:
	var input_vector = Vector2.ZERO

	# Keyboard input
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	# Add joystick if non-zero
	if joystick_vector.length_squared() > 0.01:
		input_vector = joystick_vector

	return input_vector.normalized()

func _unhandled_input(event):
	get_ping_input(event)

func get_ping_input(event) -> void:
	for action in PINGS.keys():
		if Input.is_action_just_pressed(action):
			var player = AudioStreamPlayer.new()
			player.stream = PINGS[action]
			player.bus = "Pings"
			get_tree().root.add_child(player)
			player.play()
			player.connect("finished", player.queue_free)
