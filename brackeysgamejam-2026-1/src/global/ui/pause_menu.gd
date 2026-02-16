extends CanvasLayer

@onready var resume: Button = $PauseMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Resume
@onready var settings: Button = $PauseMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Settings
@onready var exit_game: Button = $PauseMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ExitGame

func _process(delta: float) -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
