extends Node

@export var furniture_data: Array[FurnitureData]
var price: float
var seller_name: String = ""

@onready var item_label: Label = $Control/VBoxContainer/ItemLabel
@onready var location_label: Label = $Control/VBoxContainer/LocationLabel
@onready var price_label: Label = $Control/VBoxContainer/PriceLabel
@onready var seller_label: Label = $Control/VBoxContainer/SellerLabel
@onready var furniture_picture: Sprite2D = $FurniturePicture

var rng = RandomNumberGenerator.new()

var first_names: Array[String] = ["Grub", "Anthony", "Beeatrice", "Buzz", "Bugs", "Mariposa", "Archer", "Phoebee", "Luna", "Flutter", "Jiminy", "Honey", "Lady", "Dotty", "June", "Hercules"]
var last_names: Array[String] = ["Bub", "Beedle", "Queen", "Schmetterling", "Papillon", "Cricket", "Scarab", "Hornet", "Moth"]

func _ready():
	furniture_picture.texture = furniture_data[0].texture
	if furniture_data[0].is_wall:
		furniture_picture.hframes = 2
	else:
		furniture_picture.hframes = 4
	item_label.text = "Item: " + str(furniture_data.size()) + " " + furniture_data[0].name
	if furniture_data.size() > 1:
		item_label.text += "s"
	_generate_price()
	_generate_seller_name()
	
func _generate_price():
	price = (rng.randf_range(3.0, 10.0)*(furniture_data.size()*0.75))
	price = round(price*100.0) / 100.0
	price_label.text = "Price: " + str(price)

func _generate_seller_name():
	seller_name = first_names.pick_random() + " " + last_names.pick_random()
	seller_label.text = "Seller: " + seller_name
