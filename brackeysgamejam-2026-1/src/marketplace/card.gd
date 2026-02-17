extends Node

var card_data: CardData

@onready var item_label: Label = $Control/VBoxContainer/ItemLabel
@onready var location_label: Label = $Control/VBoxContainer/LocationLabel
@onready var price_label: Label = $Control/VBoxContainer/PriceLabel
@onready var seller_label: Label = $Control/VBoxContainer/SellerLabel
@onready var furniture_picture: Sprite2D = $FurniturePicture

func _ready():
	furniture_picture.texture = card_data.furniture.texture
	if card_data.furniture.is_wall:
		furniture_picture.hframes = 2
	else:
		furniture_picture.hframes = 4
	item_label.text = "Item: " + str(card_data.quantity) + " " + card_data.furniture.name
	if card_data.quantity > 1:
		item_label.text += "s"
	price_label.text = "Price: " + str(card_data.price)
	seller_label.text = "Seller: " + card_data.seller_name
