extends Control

@export var max_distance := 80.0
@onready var base = $Base
@onready var stick = $Base/Stick

var dragging := false
var origin := Vector2.ZERO

func _ready():
	visible = false

func _input(event):
	# Unified entry point
	if event is InputEventScreenTouch and event.pressed:
		_start_drag(event.position)
	elif event is InputEventMouseButton and event.pressed:
		_start_drag(event.position)
	elif (event is InputEventScreenDrag or event is InputEventMouseMotion) and dragging:
		_update_drag(event.position)
	elif event is InputEventScreenTouch and not event.pressed:
		_end_drag()
	elif event is InputEventMouseButton and not event.pressed:
		_end_drag()

func _start_drag(pos: Vector2):
	var screen_size = get_viewport_rect().size
	var canvas_pos = get_canvas_transform().affine_inverse() * pos
	if canvas_pos.x > screen_size.x * 0.5:
		return # Ignore touches outside left half
	origin = pos
	base.global_position = origin - base.size / 2
	stick.global_position = origin - stick.size / 2
	visible = true
	dragging = true
	print("Start drag at: ", origin)

func _update_drag(pos: Vector2):
	var offset = pos - origin
	var clamped = offset.limit_length(max_distance)
	stick.global_position = origin + clamped - stick.size / 2
	InputManager.joystick_vector = clamped / max_distance
	print("Dragging: ", InputManager.joystick_vector)

func _end_drag():
	dragging = false
	visible = false
	InputManager.joystick_vector = Vector2.ZERO
	print("End drag")
