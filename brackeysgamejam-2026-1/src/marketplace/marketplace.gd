extends Node

signal marketplace_closed

@onready var cards: VBoxContainer = $CanvasLayer/MarginContainer/ScrollContainer/Cards
@onready var close_button: TextureButton = $CanvasLayer/CloseButton

func _ready():
	close_button.pressed.connect(_close_marketplace)
	_populate_cards()

func _populate_cards():
	for child in cards.get_children():
		child.queue_free()

	for card in Game.current_cards:
		cards.add_child(card)

func _close_marketplace():
	marketplace_closed.emit()
	self.queue_free()
