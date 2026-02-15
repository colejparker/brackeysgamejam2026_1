extends Area2D

@export var value: int = 1

func _ready():
	body_entered.connect(_on_body_entered)

	collision_layer = 16
	collision_mask = 1

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		Game.add_money(value)
		queue_free()
