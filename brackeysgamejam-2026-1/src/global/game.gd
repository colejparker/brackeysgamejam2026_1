extends Node

@export var selected_card_data: CardData
var inventory: Array[FurnitureData] = []
var room: Dictionary[String, RoomEntry] = {}
var selected_inventory_slot = 0

var current_cards: Array[CardData] = []

var music_on: bool = true
var fx_on: bool = true
var rug_is_visible: bool = false
var items_acquired: int = 0

var pause_menu: PackedScene = preload("res://src/global/ui/pause_menu.tscn")
var card_scene: PackedScene = preload("res://src/marketplace/card.tscn")
var holding_object = false

var rng = RandomNumberGenerator.new()

signal money_changed(new_amount: int)
signal add_item_to_inventory(name: String)
signal remove_item_from_inventory(name: String)
signal remove_item_from_room(name: String)
signal update_item_in_room(name: String, furniture: FurnitureData, location: Vector2, frame: int)
signal inventory_updated()
signal card_selected()

var furniture_catalog: Dictionary[String, FurnitureData] = {}

var wall_color: Color = Color.WHITE
signal wall_color_changed(new_color: Color)

var paint_catalog: Array[PaintEntry] = []

var first_time_in_marketplace: bool = true
var first_time_in_room: bool = true
var first_time_in_frogger: bool = true
var show_winner_popup: bool = false

@export var garden_level: PackedScene = preload("res://src/bugger/levels/bugger_1.tscn")
@export var river_level: PackedScene = preload("res://src/bugger/levels/bugger_2.tscn")
@export var city_level: PackedScene = preload("res://src/bugger/levels/bugger_3.tscn")


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	prepare_furniture_catalog()
	prepare_paint_catalog()
	create_initial_room()
	generate_new_cards()
	add_item_to_inventory.connect(_on_add_item_to_inventory)
	remove_item_from_inventory.connect(_on_remove_item_from_inventory)
	remove_item_from_room.connect(_on_remove_item_from_room)
	update_item_in_room.connect(_on_update_item_in_room)

var money: float = 5.0:
	set(value):
		money = value
		money_changed.emit(money)

func add_money(amount: int):
	money += amount
	
func die_lose_money():
	money -= floor(money/2)
	
func load_next_bugger_level():
	if selected_card_data:
		if selected_card_data.location == "Garden":
			get_tree().change_scene_to_packed(garden_level)
		if selected_card_data.location == "River":
			get_tree().change_scene_to_packed(river_level)
		if selected_card_data.location == "The City":
			get_tree().change_scene_to_packed(city_level)
	
var _furniture_resources: Array[FurnitureData] = [
	preload("res://src/global/Furniture(Resources)/bed.tres"),
	preload("res://src/global/Furniture(Resources)/bookshelf.tres"),
	preload("res://src/global/Furniture(Resources)/bottlecaptable.tres"),
	preload("res://src/global/Furniture(Resources)/buttonshelf.tres"),
	preload("res://src/global/Furniture(Resources)/couch.tres"),
	preload("res://src/global/Furniture(Resources)/poster.tres"),
	preload("res://src/global/Furniture(Resources)/toothpaste_lamp.tres"),
	preload("res://src/global/Furniture(Resources)/stool.tres"),
	preload("res://src/global/Furniture(Resources)/creamerplant.tres"),
	preload("res://src/global/Furniture(Resources)/leafchair.tres"),
	preload("res://src/global/Furniture(Resources)/popsiclebench.tres"),
	preload("res://src/global/Furniture(Resources)/poptab.tres"),
	preload("res://src/global/Furniture(Resources)/stamp.tres"),
]

func prepare_furniture_catalog():
	for furniture_data in _furniture_resources:
		furniture_catalog.set(furniture_data.name, furniture_data)

func prepare_paint_catalog():
	paint_catalog.append(add_paint_to_cataog("Marketplace White", Color(0.92, 0.93, 0.92)))
	paint_catalog.append(add_paint_to_cataog("Light Grey", Color(0.78, 0.81, 0.80)))
	paint_catalog.append(add_paint_to_cataog("Title Screen Olive", Color(0.82, 0.85, 0.57)))
	paint_catalog.append(add_paint_to_cataog("Pink", Color(0.86, 0.52, 0.65)))
	paint_catalog.append(add_paint_to_cataog("Sky Blue", Color(0.45, 0.75, 0.83)))
	paint_catalog.append(add_paint_to_cataog("Green", Color(0.66, 0.80, 0.35)))
	paint_catalog.append(add_paint_to_cataog("Menu Beige", Color(0.84, 0.71, 0.58)))
	paint_catalog.append(add_paint_to_cataog("Bugbook Slate", Color(0.51, 0.59, 0.59)))
	paint_catalog.append(add_paint_to_cataog("Red No. 40", Color(0.65, 0.19, 0.19)))
	paint_catalog.append(add_paint_to_cataog("Gooey Brown", Color(0.68, 0.47, 0.34)))
	paint_catalog.append(add_paint_to_cataog("Beige", Color(0.91, 0.84, 0.70)))
	
func add_paint_to_cataog(paint_name: String, paint_color: Color) -> PaintEntry:
	var paint_entry = PaintEntry.new()
	paint_entry.name = paint_name
	paint_entry.color = paint_color
	return paint_entry

var first_names: Array[String] = ["Grub", "Anthony", "Beeatrice", "Buzz", "Bugs", "Mariposa", "Archer", "Phoebee", "Luna", "Flutter", "Jiminy", "Honey", "Lady", "Dotty", "June", "Hercules"]
var last_names: Array[String] = ["Bub", "Beedle", "Queen", "Schmetterling", "Papillon", "Cricket", "Scarab", "Hornet", "Moth"]

func generate_new_cards():
	current_cards.clear()

	if furniture_catalog.is_empty():
		return

	if (items_acquired >= 10):
		var rug_card = CardData.new()
		rug_card.is_paint = false
		rug_card.quantity = 1
		rug_card.price = 10.00
		rug_card.location = _generate_location()
		rug_card.seller_name = "Kiran Hughes"
		var furniture = FurnitureData.new()
		furniture.name = "Rug"
		rug_card.furniture = furniture
		current_cards.append(rug_card)
	var num_cards = rng.randi_range(3, 6)

	for n in num_cards:
		var ran_num_items = rng.randi_range(1, 10)
		var num_items = 1
		if ran_num_items == 10:
			num_items = 3
		elif ran_num_items >= 8:
			num_items = 2

		var card_data = CardData.new()
		card_data.furniture = furniture_catalog.values().pick_random()
		card_data.quantity = num_items
		card_data.price = rng.randf_range(3.0, 10.0) * (num_items * 0.75)
		card_data.price = round(card_data.price * 100.0) / 100.0
		card_data.location = _generate_location()
		card_data.seller_name = first_names.pick_random() + " " + last_names.pick_random()

		current_cards.append(card_data)

	var paint_entry = paint_catalog.pick_random()
	var paint_card = CardData.new()
	paint_card.is_paint = true
	paint_card.color = paint_entry["color"]
	paint_card.quantity = 1
	paint_card.price = rng.randf_range(3.0, 10.0)
	paint_card.price = round(paint_card.price * 100.0) / 100.0
	paint_card.location =  _generate_location()
	paint_card.seller_name = first_names.pick_random() + " " + last_names.pick_random()
	current_cards.append(paint_card)

func _input(event):
	if event.is_action_pressed("escape"):
		if get_tree().current_scene.scene_file_path.contains("game.tscn"):
			return
		get_tree().paused = !get_tree().paused

		if get_tree().paused:
			var pause_node = pause_menu.instantiate()
			get_tree().current_scene.add_child(pause_node)
		else:
			var pause_node = get_tree().current_scene.get_node_or_null("PauseMenu")
			if pause_node:
				pause_node.queue_free()
			var settings_node = get_tree().current_scene.get_node_or_null("SettingsMenu")
			if settings_node:
				settings_node.queue_free()
				
func _on_add_item_to_inventory(name: String):
	inventory.append(furniture_catalog.get(name))
	inventory_updated.emit()
	
func _on_remove_item_from_inventory(name: String):
	var index_to_remove = -1
	for i in inventory.size():
		if inventory[i].name == name:
			index_to_remove = i
			break
	if index_to_remove >= 0:
		inventory.remove_at(index_to_remove)
	inventory_updated.emit()
	
func create_initial_room():
	var computer = RoomEntry.new().initialize("Computer", preload("res://src/global/Furniture(Resources)/apple.tres"), Vector2(352,80), 0)
	var door = RoomEntry.new().initialize("DoorOut", preload("res://src/global/Furniture(Resources)/doormat.tres"), Vector2(322,316), 2)
	room.set(computer.name, computer)
	room.set(door.name, door)

func select_card_data(card_data: CardData):
	selected_card_data = card_data
	card_selected.emit()

func _on_remove_item_from_room(name: String) -> void:
	room.erase(name)
	print(room)
	
func _on_update_item_in_room(name: String, furniture: FurnitureData, location: Vector2, frame: int) -> void:
	var room_entry: RoomEntry
	if room.has(name):
		room_entry = room.get(name)
	else:
		room_entry = RoomEntry.new()
	room_entry.initialize(name, furniture, location, frame)
	room.set(name, room_entry)
	print(room)

func _attempt_purchase_furniture() -> bool:
	if (money >= selected_card_data.price):
		money -= selected_card_data.price
		if selected_card_data.is_paint:
			wall_color = selected_card_data.color
			wall_color_changed.emit(wall_color)
			items_acquired += 1
		elif selected_card_data.furniture.name == "Rug":
			rug_is_visible = true
			show_winner_popup = true
		else:
			items_acquired += selected_card_data.quantity
			for i in selected_card_data.quantity:
				_on_add_item_to_inventory(selected_card_data.furniture.name)
		generate_new_cards()
		selected_card_data = null
		return true
	else:
		return false

func _toggle_music():
	music_on = !music_on
	if (music_on):
		MusicPlayer.start()
	else:
		MusicPlayer.stop()

func _toggle_fx():
	fx_on = !fx_on
	
func _generate_location() -> String:
	var level_array: Array[String] = ["Garden", "River", "The City"]
	return level_array.pick_random()
