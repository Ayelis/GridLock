#/src/Map.gd
extends TileMapLayer

@export var speed := 200.0
@onready var player := get_node("../PlayerCharacter")
@onready var player_sprite := player.get_node("AnimatedSprite2D")

func _physics_process(delta):
	var input = InputManager.get_move_input()
	update_player_direction(input)
	position -= input * speed * delta

func update_player_direction(movement: Vector2):
	if movement.length() < 0.1:
		return

	var angle = movement.angle() + deg_to_rad(90)

	var deg = rad_to_deg(angle)
	var normalized_angle = fposmod(deg, 360.0)  # Safer float mod

	var total_frames := 36.0
	var frame_index = int(round(normalized_angle / (360.0 / total_frames))) % int(total_frames)

	if not player_sprite:
		return
	#player_sprite.play("move")
	player_sprite.frame = frame_index
