extends Node

signal marketplace_closed

@onready var cards: VBoxContainer = $CanvasLayer/MarginContainer/ScrollContainer/Cards
@onready var close_button: TextureButton = $CanvasLayer/CloseButton
@onready var popup_menu: CanvasLayer = $CanvasLayer/PopupMenu
@onready var help_button: TextureButton = $CanvasLayer/HelpButton

var card_scene: PackedScene = preload("res://src/marketplace/card.tscn")

func _ready():
	if Game.first_time_in_marketplace:
		popup_menu.visible = true
		Game.first_time_in_marketplace = false
	close_button.pressed.connect(_close_marketplace)
	Game.card_selected.connect(_close_marketplace)
	help_button.pressed.connect(open_popup)
	_populate_cards()

func _populate_cards():
	for child in cards.get_children():
		child.queue_free()

	for card_data in Game.current_cards:
		var card = card_scene.instantiate()
		card.card_data = card_data
		cards.add_child(card)

func _close_marketplace():
	marketplace_closed.emit()
	self.queue_free()

func open_popup():
	popup_menu.visible = true
