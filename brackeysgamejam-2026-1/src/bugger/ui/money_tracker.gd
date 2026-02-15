extends Label

@export var next_bugger_level: PackedScene
@export var next_furniture_item: PackedScene
@export var cost_of_next_item: float = 1.0

func _ready():
	Game.money_changed.connect(_on_money_changed)
	_update_display(Game.money)

func _on_money_changed(new_amount: int):
	_update_display(new_amount)

func _update_display(amount: int):
	text = "Money: " + str(amount)
