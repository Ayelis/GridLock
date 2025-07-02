#/src/UI.gd
extends CanvasLayer

var screens := []
var audio_player := AudioStreamPlayer.new()

const annoucements = {
	1: "res://resources/audio/announcer/ready.ogg",
	2: "res://resources/audio/announcer/final_round.ogg",
	3: "res://resources/audio/announcer/you_win.ogg",
}

func _ready():
	audio_player.bus = "Announcer"
	add_child(audio_player)
	#get_tree().root.add_child(audio_player)
	screens = [ $MainMenu, $Lobby, $GameUI, $Results ]
	
	# Connect each TextureButton's pressed signal
	for i in range(screens.size()):
		var screen = screens[i]
		var button: TextureButton = screen.get_node("TextureButton")
		if button:
			button.pressed.connect(_on_screen_button_pressed.bind(i))
	show_screen(0)

# Call this to play any sound
func play_audio(sound_path: String) -> void:
	#audio_player.connect("finished", audio_player.queue_free)
	audio_player.stream = load(sound_path)  # Load the sound dynamically
	audio_player.play()

func _on_screen_button_pressed(current_index: int) -> void:
	var next_index = (current_index + 1) % screens.size()
	show_screen(next_index)
	if(next_index==2):
		$"../Camera2D".visible = true
		$"../World".visible = true
	else:
		$"../Camera2D".visible = false
		$"../World".visible = false
	if(next_index!=0):
		play_audio(annoucements[next_index])

func show_screen(index: int) -> void:
	for i in range(screens.size()):
		screens[i].visible = (i == index)
