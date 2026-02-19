extends CanvasLayer

@onready var button: Button = $PauseMenuBase/NinePatchRect/Button

func _ready() -> void:
	button.pressed.connect(close_credits)
	
func close_credits():
	queue_free()
