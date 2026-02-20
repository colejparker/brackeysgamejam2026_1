extends CanvasLayer

@onready var button: Button = $PauseMenuBase/NinePatchRect/Button

const CLICK = preload("uid://dbj0nhfjsue07")

func _ready() -> void:
	button.pressed.connect(close_credits)
	
func close_credits():
	SoundFxPlayer._play_sound(CLICK)
	queue_free()
