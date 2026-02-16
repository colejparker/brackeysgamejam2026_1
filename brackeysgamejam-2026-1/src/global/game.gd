extends Node

@export var next_bugger_level: PackedScene = preload("res://src/bugger/levels/bugger_1.tscn")
@export var next_furniture_item: PackedScene
@export var cost_of_next_item: float = 1.0

var pause_menu: PackedScene = preload("res://src/global/ui/pause_menu.tscn")

signal money_changed(new_amount: int)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

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

func _input(event):
	if event.is_action_pressed("escape"):
		if get_tree().current_scene.scene_file_path.contains("game.tscn"):
			return
		get_tree().paused = !get_tree().paused

		if get_tree().paused:
			var pause_node = pause_menu.instantiate()
			get_tree().current_scene.add_child(pause_node)
			print("Game Paused")
		else:
			var pause_node = get_tree().current_scene.get_node_or_null("PauseMenu")
			if pause_node:
				pause_node.queue_free()
			print("Game Resumed")
