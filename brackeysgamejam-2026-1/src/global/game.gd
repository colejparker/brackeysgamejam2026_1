extends Node

@export var next_bugger_level: PackedScene = preload("res://src/bugger/levels/bugger_1.tscn")
@export var next_furniture_item: Array[FurnitureData]
@export var cost_of_next_item: float = 1.0
@export var available_furniture: Array[FurnitureData]

var current_cards: Array[Node] = []

var pause_menu: PackedScene = preload("res://src/global/ui/pause_menu.tscn")
var card_scene: PackedScene = preload("res://src/marketplace/card.tscn")

var rng = RandomNumberGenerator.new()

signal money_changed(new_amount: int)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_available_furniture()
	generate_new_cards()

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

func load_available_furniture():
	available_furniture.clear()

	var furniture_dir = "res://src/global/Furniture(Resources)/"
	var dir = DirAccess.open(furniture_dir)

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if !dir.current_is_dir() and file_name.ends_with(".tres"):
				var full_path = furniture_dir + file_name
				var furniture = load(full_path) as FurnitureData

				if furniture:
					available_furniture.append(furniture)

			file_name = dir.get_next()

		dir.list_dir_end()

func generate_new_cards():
	current_cards.clear()

	if available_furniture.is_empty():
		return

	var num_cards = rng.randi_range(3, 6)

	for n in num_cards:
		var card = card_scene.instantiate()

		var num_items = rng.randi_range(1, 3)
		var random_furniture = available_furniture.pick_random()
		var furniture_for_card: Array[FurnitureData] = []

		for i in num_items:
			furniture_for_card.append(random_furniture)

		card.furniture_data = furniture_for_card

		current_cards.append(card)


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
