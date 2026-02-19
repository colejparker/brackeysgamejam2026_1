extends CanvasLayer

@onready var texture_button: TextureButton = $PauseMenuBase/NinePatchRect/TextureButton

func _ready() -> void:
	texture_button.pressed.connect(close_credits)
	
func close_credits():
	queue_free()
