extends CanvasLayer

var screens := []

func _ready():
	screens = [ $MainMenu, $Lobby, $GameUI, $Results ]

	# Connect each TextureButton's pressed signal
	for i in range(screens.size()):
		var screen = screens[i]
		var button: TextureButton = screen.get_node("TextureButton")
		if button:
			button.pressed.connect(_on_screen_button_pressed.bind(i))
	show_screen(0)

func _on_screen_button_pressed(current_index: int) -> void:
	var next_index = (current_index + 1) % screens.size()
	show_screen(next_index)
	if(next_index==2):
		$"../Camera2D".visible = true
		$"../World".visible = true
	else:
		$"../Camera2D".visible = false
		$"../World".visible = false

func show_screen(index: int) -> void:
	for i in range(screens.size()):
		screens[i].visible = (i == index)
