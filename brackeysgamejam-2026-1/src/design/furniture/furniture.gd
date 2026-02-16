extends CharacterBody2D

@onready var parent_tile_map_layer = get_parent() as TileMapLayer
@onready var collection_shape = $CollisionShape2D
@onready var sprite =$Sprite2D
@export var is_wall = false

enum State {
	STATIONARY,
	MOVING,
}

var state = State.STATIONARY

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_local_mouse_position()
		if state == State.STATIONARY and mouse_in_rect():
			print("!")
			state = State.MOVING
			
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		state = State.STATIONARY
		
	if Input.is_action_just_pressed("rotate") and (mouse_in_rect() or state == State.MOVING):
		sprite.frame = (sprite.frame + 1) % sprite.hframes
	
	if state == State.MOVING:
		var desired_position = get_desired_position(Input.is_action_pressed("snapToGrid"))
		var motion = (desired_position - position)
		move_and_collide(motion)


func mouse_in_rect() -> bool:
	return collection_shape.get_shape().get_rect().has_point(get_local_mouse_position())
	
func get_desired_position(snap: bool) -> Vector2:
	if snap:
		return parent_tile_map_layer.map_to_local(parent_tile_map_layer.local_to_map(get_global_mouse_position()))
	return get_global_mouse_position()
