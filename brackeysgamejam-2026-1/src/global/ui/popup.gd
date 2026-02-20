extends CanvasLayer
@onready var button: Button = $PauseMenuBase/NinePatchRect/Button

@export var title_text: String = ""
@export var body_text: String = ""
@onready var title: Label = $PauseMenuBase/MarginContainer/VBoxContainer/Title
@onready var body: RichTextLabel = $PauseMenuBase/MarginContainer/VBoxContainer/Body
const CLICK = preload("uid://dbj0nhfjsue07")

func _ready() -> void:
	button.pressed.connect(close_popup)
	title.text = title_text
	body.text = body_text
	
func close_popup():
	SoundFxPlayer._play_sound(CLICK)
	self.visible = false
