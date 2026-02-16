extends Node

signal marketplace_closed

@onready var cards: VBoxContainer = $CanvasLayer/MarginContainer/ScrollContainer/Cards
@onready var close_button: TextureButton = $CanvasLayer/CloseButton

func _ready():
	close_button.pressed.connect(_close_marketplace)

func _close_marketplace():
	marketplace_closed.emit()
	self.queue_free()
