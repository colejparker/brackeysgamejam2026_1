extends Node

var card_data: CardData

@onready var item_label: Label = $Control/VBoxContainer/ItemLabel
@onready var location_label: Label = $Control/VBoxContainer/LocationLabel
@onready var price_label: Label = $Control/VBoxContainer/PriceLabel
@onready var seller_label: Label = $Control/VBoxContainer/SellerLabel
@onready var furniture_picture: Sprite2D = $FurniturePicture
@onready var paint_color_rect: ColorRect = $PaintColorRect
@onready var message_button: TextureButton = $MessageButton

func _ready():
	if card_data:
		_setup(card_data)
		message_button.pressed.connect(_click_card)
	elif Game.selected_card_data != null:
		_setup(Game.selected_card_data)
		message_button.visible = false
	else:
		self.visible = false

func _click_card():
	Game.select_card_data(card_data)
	
func _setup(assigned_card_data: CardData):
	if assigned_card_data.is_paint:
		furniture_picture.texture = preload("res://assets/ui_cole/paintbucket.png")
		furniture_picture.hframes = 1
		paint_color_rect.color = assigned_card_data.color
		paint_color_rect.visible = true
		var paint_name = _get_paint_name(assigned_card_data.color)
		item_label.text = "Paint: " + paint_name
	else:
		furniture_picture.texture = assigned_card_data.furniture.texture
		if assigned_card_data.furniture.is_wall:
			furniture_picture.hframes = 2
		else:
			furniture_picture.hframes = 4
		if assigned_card_data.furniture.size_config == FurnitureData.SizeConfig.TWO_BY_ONE:
			furniture_picture.scale = Vector2(.8, .8)
			furniture_picture.position = Vector2(65, 55.5)
		item_label.text = "Item: " + str(assigned_card_data.quantity) + " " + assigned_card_data.furniture.name
		if assigned_card_data.quantity > 1:
			item_label.text += "s"
	price_label.text = "Price: " + str(assigned_card_data.price)
	seller_label.text = "Seller: " + assigned_card_data.seller_name
	location_label.text = "Location: " + assigned_card_data.location

func _get_paint_name(color: Color) -> String:
	for entry in Game.paint_catalog:
		if entry.color == color:
			return entry.name
	return "Paint"
	
