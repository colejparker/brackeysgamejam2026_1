extends CharacterBody2D

@onready var parent_tile_map_layer = get_parent() as TileMapLayer
@onready var sprite = $Sprite2D

@export var furniture_data: FurnitureData
@export var starting_frame: int = 0

var selected_collision_shapes: Array[CollisionPolygon2D] = []

enum State {
	STATIONARY,
	MOVING,
}

var state = State.STATIONARY

func _physics_process(delta: float) -> void:
	if name == "DoorOut":
		return
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

	
	if Input.is_action_just_pressed("rotate") and state == State.MOVING and !furniture_data.is_wall:
		get_collision_shape().disabled = true
		sprite.frame = (sprite.frame + 1) % sprite.hframes
		get_collision_shape().disabled = false
		has_changed = true
		
	if Input.is_action_just_pressed("stash") and (mouse_in_rect() or state == State.MOVING) and name != "Computer":
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
	return Geometry2D.is_point_in_polygon(point, get_collision_shape().polygon)
	
func get_collision_shape() -> CollisionPolygon2D:
	if selected_collision_shapes.size() > 1:
		return selected_collision_shapes[sprite.frame]
	else:
		return selected_collision_shapes[0]

func get_desired_position(snap: bool) -> Vector2:
	var desired_pos = get_global_mouse_position()
	desired_pos.x -= 32
	if snap:
		return parent_tile_map_layer.map_to_local(parent_tile_map_layer.local_to_map(desired_pos))
	if desired_pos.x >= 338 and desired_pos.x <= 362 and furniture_data.is_wall:
		desired_pos.x = 338
	return desired_pos

func prepare_collision_shapes(size_config: FurnitureData.SizeConfig):
	match size_config:
		FurnitureData.SizeConfig.ONE_BY_ONE: selected_collision_shapes = [$OneByOneCollision]
		FurnitureData.SizeConfig.TWO_BY_ONE: 
			selected_collision_shapes = [
				$TwoByOneCollisionOne,
				$TwoByOneCollisionTwo,
				$TwoByOneCollisionThree,
				$TwoByOneCollisionFour,
			]

func _ready():
	prepare_collision_shapes(furniture_data.size_config)
	sprite.texture = furniture_data.texture
	if furniture_data.is_wall:
		sprite.hframes = 2
	sprite.frame = starting_frame
	get_collision_shape().disabled = false
