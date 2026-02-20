extends Area2D

@export var value: int = 1

const PULSE_SCALE: float = 0.05
const PULSE_SPEED: float = 4.0

var time: float = 0.0

const PICKUP = preload("uid://clwfpnvorqn5k")

func _ready():
	body_entered.connect(_on_body_entered)

	collision_layer = 16
	collision_mask = 1

func _process(delta: float) -> void:
	time += delta
	var scale_offset = sin(time * PULSE_SPEED) * PULSE_SCALE
	scale = Vector2.ONE * (1.0 + scale_offset)

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		SoundFxPlayer._play_sound(PICKUP)
		Game.add_money(value)
		queue_free()
