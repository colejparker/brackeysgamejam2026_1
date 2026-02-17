extends Node

@export var next_bugger_level: PackedScene = preload("res://src/bugger/levels/bugger_1.tscn")
@export var next_furniture_item: Array[FurnitureData]
@export var cost_of_next_item: float = 1.0
var inventory: Array[FurnitureData] = []
var selected_inventory_slot = 0

var current_cards: Array[CardData] = []

var pause_menu: PackedScene = preload("res://src/global/ui/pause_menu.tscn")
var card_scene: PackedScene = preload("res://src/marketplace/card.tscn")

var rng = RandomNumberGenerator.new()

signal money_changed(new_amount: int)
signal add_item_to_inventory(name: String)
signal remove_item_from_inventory(name: String)
signal inventory_updated()

var furniture_catalog: Dictionary[String, FurnitureData] = {}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	prepare_furniture_catalog()
	generate_new_cards()
	add_item_to_inventory.connect(_on_add_item_to_inventory)
	remove_item_from_inventory.connect(_on_remove_item_from_inventory)

var money: int = 5:
	set(value):
		money = value
		money_changed.emit(money)

func add_money(amount: int):
	money += amount
	
func die_lose_money():
	money -= floor(money/2)
	
func load_next_bugger_level():
	get_tree().change_scene_to_packed(next_bugger_level)
	
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
