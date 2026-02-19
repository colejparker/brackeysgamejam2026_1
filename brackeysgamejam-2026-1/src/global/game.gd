extends Node

@export var selected_card_data: CardData
var inventory: Array[FurnitureData] = []
var room: Dictionary[String, RoomEntry] = {}
var selected_inventory_slot = 0

var current_cards: Array[CardData] = []

var music_on: bool = true
var fx_on: bool = true

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

@export var garden_level: PackedScene = preload("res://src/bugger/levels/bugger_1.tscn")

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	prepare_furniture_catalog()
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
	
func prepare_furniture_catalog():
	const FURNITURE_RESOURCE_DIR = "res://src/global/Furniture(Resources)/"
	for file_name in DirAccess.get_files_at(FURNITURE_RESOURCE_DIR):
		if file_name.ends_with(".tres"):
			var furniture_data = ResourceLoader.load(FURNITURE_RESOURCE_DIR + file_name) as FurnitureData
			furniture_catalog.set(furniture_data.name, furniture_data)

var first_names: Array[String] = ["Grub", "Anthony", "Beeatrice", "Buzz", "Bugs", "Mariposa", "Archer", "Phoebee", "Luna", "Flutter", "Jiminy", "Honey", "Lady", "Dotty", "June", "Hercules"]
var last_names: Array[String] = ["Bub", "Beedle", "Queen", "Schmetterling", "Papillon", "Cricket", "Scarab", "Hornet", "Moth"]

func generate_new_cards():
	current_cards.clear()

	if furniture_catalog.is_empty():
		return

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
		card_data.location = "Garden"
		card_data.seller_name = first_names.pick_random() + " " + last_names.pick_random()

		current_cards.append(card_data)


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
	var door = RoomEntry.new().initialize("DoorOut", preload("res://src/global/Furniture(Resources)/apple.tres"), Vector2(322,316), 2)
	var poster = RoomEntry.new().initialize("Poster", preload("res://src/global/Furniture(Resources)/poster.tres"), Vector2(170,80), 0)
	var bed = RoomEntry.new().initialize("Bed", preload("res://src/global/Furniture(Resources)/bed.tres"), Vector2(200,200), 0)
	room.set(computer.name, computer)
	room.set(door.name, door)
	room.set(poster.name, poster)
	room.set(bed.name, bed)

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
		for i in selected_card_data.quantity:
			_on_add_item_to_inventory(selected_card_data.furniture.name)
		generate_new_cards()
		selected_card_data = null
		return true
	else:
		return false

func _toggle_music():
	music_on = !music_on

func _toggle_fx():
	fx_on = !fx_on
