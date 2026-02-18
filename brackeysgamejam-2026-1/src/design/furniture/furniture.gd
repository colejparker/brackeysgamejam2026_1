extends CharacterBody2D

@onready var parent_tile_map_layer = get_parent() as TileMapLayer
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D

@export var furniture_data: FurnitureData
@export var starting_frame: int = 0

enum State {
	STATIONARY,
	MOVING,
}

var state = State.STATIONARY

func _physics_process(delta: float) -> void:
	var has_changed = false
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_local_mouse_position()
		if state == State.STATIONARY and mouse_in_rect() and !Game.holding_object:
			Game.holding_object = true
			state = State.MOVING
			
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		has_changed = (state == State.MOVING)
		state = State.STATIONARY
		Game.holding_object = false
		
	if Input.is_action_just_pressed("rotate") and (mouse_in_rect() or state == State.MOVING) and !furniture_data.is_wall:
		sprite.frame = (sprite.frame + 1) % sprite.hframes
		has_changed = true
		
	if Input.is_action_just_pressed("stash") and (mouse_in_rect() or state == State.MOVING):
		Game.add_item_to_inventory.emit(furniture_data.name)
		Game.remove_item_from_room.emit(name)
		queue_free()
		return

	if furniture_data.is_wall:
		sprite.frame = 0 if position.x <= 350 else 1
	
	if state == State.MOVING:
		var desired_position = get_desired_position(Input.is_action_pressed("snapToGrid"))
		var motion = (desired_position - position)
		move_and_collide(motion)
	if has_changed:
		Game.update_item_in_room.emit(name, furniture_data, position, sprite.frame)

func mouse_in_rect() -> bool:
	return point_in_rect(get_local_mouse_position())
	
func point_in_rect(point: Vector2) -> bool:
	return collision_shape.get_shape().get_rect().has_point(point)
	
func get_desired_position(snap: bool) -> Vector2:
	var desired_pos = get_global_mouse_position()
	desired_pos.x -= 32
	if snap:
		return parent_tile_map_layer.map_to_local(parent_tile_map_layer.local_to_map(desired_pos))
	if desired_pos.x >= 338 and desired_pos.x <= 362 and furniture_data.is_wall:
		desired_pos.x = 338
	return desired_pos

func _ready():
	sprite.texture = furniture_data.texture
	if furniture_data.is_wall:
		sprite.hframes = 2
	sprite.frame = starting_frame
