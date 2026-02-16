extends CharacterBody2D

var input_vector = Vector2.ZERO

const SPEED = 100.0

@onready var animation_tree: AnimationTree = $AnimationTree

func _physics_process(delta: float) -> void:
	input_vector = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	
	if input_vector != Vector2.ZERO:
		var animation_direction_vector = Vector2(input_vector.x, -input_vector.y)
		update_blend_positions(animation_direction_vector)
	
	velocity = input_vector * SPEED
	move_and_slide()
		
	
	
func update_blend_positions(direction_vector: Vector2) -> void:
	animation_tree.set("parameters/StateMachine/MoveState/RunState/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/MoveState/StandState/blend_position", direction_vector)
