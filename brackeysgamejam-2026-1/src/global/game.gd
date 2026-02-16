extends Node

@export var next_bugger_level: PackedScene
@export var next_furniture_item: PackedScene
@export var cost_of_next_item: float = 1.0

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
	
func _input(event):
	if event.is_action_pressed("escape"):
		if get_tree().current_scene.scene_file_path.contains("game.tscn"):
			return
		get_tree().paused = !get_tree().paused
		# To-Do: Create Pause Menu to Instantiate Here
		if get_tree().paused:
			print("Game Paused")
		else:
			print("Game Resumed")
		
