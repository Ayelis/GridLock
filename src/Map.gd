extends TileMapLayer

@export var speed := 200.0

func _physics_process(delta):
	var input = InputManager.get_move_input()
	position -= input * speed * delta
