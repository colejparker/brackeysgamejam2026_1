extends CanvasLayer

@onready var resume: Button = $PauseMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Resume
@onready var settings: Button = $PauseMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Settings
@onready var exit_game: Button = $PauseMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ExitGame

var settings_menu: PackedScene = preload("res://src/global/ui/settings.tscn")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume.pressed.connect(_unpause)
	settings.pressed.connect(_open_settings)
	exit_game.pressed.connect(_quit_game)

func _unpause():
	get_tree().paused = !get_tree().paused
	queue_free()

func _open_settings():
	var settings_node = settings_menu.instantiate()
	get_tree().current_scene.add_child(settings_node)

func _quit_game():
	get_tree().quit()
