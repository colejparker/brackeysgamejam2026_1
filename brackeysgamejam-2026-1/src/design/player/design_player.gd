extends CharacterBody2D

var input_vector = Vector2.ZERO
var last_direction = Vector2.ZERO

const SPEED = 100.0

@onready var animation_tree: AnimationTree = $AnimationTree
var marketplace: PackedScene = preload("res://src/marketplace/marketplace.tscn")
var marketplace_open: bool = false
var can_trigger_computer: bool = true
var is_touching_computer: bool = false
@onready var gui: CanvasLayer = $"../DesignGUI"

func _physics_process(delta: float) -> void:
	if marketplace_open:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	input_vector = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")

	if input_vector != Vector2.ZERO:
		last_direction = input_vector
		var animation_direction_vector = Vector2(input_vector.x, -input_vector.y)
		update_blend_positions(animation_direction_vector)

		if is_touching_computer:
			can_trigger_computer = false

	velocity = input_vector * SPEED
	move_and_slide()

	var currently_touching_computer = false

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.name == "DoorOut":
			Game.load_next_bugger_level()
		elif collider and collider.name == "Computer":
			currently_touching_computer = true
			if can_trigger_computer and not marketplace_open:
				_open_marketplace()

	if not currently_touching_computer and is_touching_computer:
		can_trigger_computer = true

	is_touching_computer = currently_touching_computer

func _open_marketplace() -> void:
	if get_tree().current_scene.has_node("Marketplace"):
		return

	marketplace_open = true
	can_trigger_computer = false
	var marketplace_node = marketplace.instantiate()
	marketplace_node.name = "Marketplace"
	marketplace_node.marketplace_closed.connect(_on_marketplace_closed)
	gui.visible = false
	get_tree().current_scene.add_child(marketplace_node)

func _on_marketplace_closed() -> void:
	marketplace_open = false
	gui.visible = true

func update_blend_positions(direction_vector: Vector2) -> void:
	animation_tree.set("parameters/StateMachine/StandState/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/RunState/blend_position", direction_vector)
