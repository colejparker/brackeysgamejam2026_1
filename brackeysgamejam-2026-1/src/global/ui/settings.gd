extends CanvasLayer

@onready var music: CheckButton = $PauseMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Music
@onready var sound_fx: CheckButton = $PauseMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/SoundFX
@onready var exit_settings_button: Button = $PauseMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ExitSettingsButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	music.button_pressed = Game.music_on
	sound_fx.button_pressed = Game.fx_on
	music.pressed.connect(_toggle_music)
	sound_fx.pressed.connect(_toggle_fx)
	exit_settings_button.pressed.connect(_exit_settings)
	
func _toggle_music():
	Game._toggle_music()

func _toggle_fx():
	Game._toggle_fx()

func _exit_settings():
	queue_free()
	
