extends CanvasLayer

@onready var resume: Button = $PauseMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Resume
@onready var settings: Button = $PauseMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Settings
@onready var exit_game: Button = $PauseMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ExitGame
@onready var pause_menu_base: MarginContainer = $PauseMenuBase
@onready var texture_rect: TextureRect = $TextureRect
@onready var selected_card_label: Label = $SelectedCardLabel

var settings_menu: PackedScene = preload("res://src/global/ui/settings.tscn")
const CLICK = preload("uid://dbj0nhfjsue07")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume.pressed.connect(_unpause)
	settings.pressed.connect(_open_settings)
	exit_game.pressed.connect(_quit_game)
	if Game.selected_card_data == null:
		pause_menu_base.global_position[1] = 50
		selected_card_label.visible = false

func _unpause():
	SoundFxPlayer._play_sound(CLICK)
	get_tree().paused = !get_tree().paused
	queue_free()

func _open_settings():
	SoundFxPlayer._play_sound(CLICK)
	var settings_node = settings_menu.instantiate()
	get_tree().current_scene.add_child(settings_node)

func _quit_game():
	SoundFxPlayer._play_sound(CLICK)
	get_tree().quit()
