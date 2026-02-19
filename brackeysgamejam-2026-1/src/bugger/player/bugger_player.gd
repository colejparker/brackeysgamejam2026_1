extends CharacterBody2D


@onready var sprite_2d: Sprite2D = $Sprite2D
const GRID_SIZE: int = 32
var START_X: int = 0
var START_Y: int = 0

var texture_alive: Texture2D = preload("res://assets/sprites/mainbugguy.png")
var texture_dead: Texture2D = preload("res://assets/sprites/mainbugguy-dead.png")

@onready var load_room = preload("res://src/design/world/design_world.tscn")

var target_position: Vector2  = Vector2.ZERO
var current_log: Area2D = null
var last_log_position: Vector2 = Vector2.ZERO
var picked_up_furniture: bool = false
@onready var help_button: TextureButton = $"../BuggerLayer/HelpButton"

var is_resetting: bool = false
@onready var return_home_menu: CanvasLayer = $"../ReturnHomeMenu"
@onready var cancel_return: Button = $"../ReturnHomeMenu/ReturnHomeMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/CancelReturn"
@onready var return_home: Button = $"../ReturnHomeMenu/ReturnHomeMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ReturnHome"
@onready var home: Area2D = $"../ObstacleLayer/Home"
@onready var end_house: Area2D = $"../ObstacleLayer/EndHouse"
@onready var water_layer: TileMapLayer = $"../TileMap/WaterLayer"
@onready var pop_up_menu: CanvasLayer = $"../PopUp Menu"
@onready var money_tracker: Label = $"../BuggerLayer/MoneyTracker"

func _ready():
	if Game.first_time_in_frogger:
		Game.first_time_in_frogger = false
		pop_up_menu.visible = true
	return_home_menu.visible = false
		
	START_X = home.global_position[0]
	START_Y = home.global_position[1]+32.0
	global_position[0] = START_X
	global_position[1] = START_Y
	
	cancel_return.pressed.connect(_dismiss_return_menu)
	return_home.pressed.connect(_return_home)
	
	global_position = global_position.snapped(Vector2(GRID_SIZE, GRID_SIZE))
	target_position = global_position

	collision_layer = 1
	collision_mask = 2 | 4
	
	help_button.pressed.connect(open_popup)

func _process(_delta):
	if is_resetting:
		return
	if current_log and is_instance_valid(current_log):
		var log_delta = current_log.global_position - last_log_position
		if log_delta != Vector2.ZERO:
			global_position += log_delta
			global_position = global_position.snapped(Vector2(GRID_SIZE, GRID_SIZE))
			target_position = global_position
			if _is_on_water(global_position):
				die()
				return
	var log = _get_water_safe_area_at(global_position)
	current_log = log
	if log:
		last_log_position = log.global_position

	var input_dir: Vector2 = _get_input_direction()
	if (input_dir != Vector2.ZERO) and !return_home_menu.visible:
		var new_position: Vector2 = (global_position + input_dir * GRID_SIZE).snapped(Vector2(GRID_SIZE, GRID_SIZE))

		if not _is_position_blocked(new_position):
			global_position = new_position
			target_position = new_position
			current_log = _get_water_safe_area_at(global_position)
			if current_log:
				last_log_position = current_log.global_position
			if _is_on_water(new_position):
				die()
		elif _is_touching_home(new_position):
			return_home_menu.visible = true
		elif _is_touching_end_house(new_position) and !picked_up_furniture:
			if (Game._attempt_purchase_furniture()):
				picked_up_furniture = true
				START_X = end_house.global_position[0]
				START_Y = end_house.global_position[1]+32.0
			else:
				money_tracker._cannot_afford()
			
			

func _get_input_direction() -> Vector2:
	if (Input.is_action_just_pressed("moveUp")):
		sprite_2d.rotation_degrees = 0
		return Vector2.UP
	elif (Input.is_action_just_pressed("moveDown")):
		sprite_2d.rotation_degrees = 180
		return Vector2.DOWN
	elif (Input.is_action_just_pressed("moveRight")):
		sprite_2d.rotation_degrees = 90
		return Vector2.RIGHT
	elif (Input.is_action_just_pressed("moveLeft")):
		sprite_2d.rotation_degrees = 270
		return Vector2.LEFT
	return Vector2.ZERO
	

func _get_area_at(pos: Vector2, mask: int) -> Area2D:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collision_mask = mask
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var results = space_state.intersect_point(query)
	if results.size() > 0:
		return results[0]["collider"]
	return null

func _is_position_blocked(pos: Vector2) -> bool:
	return _get_area_at(pos, 4) != null

func _get_water_safe_area_at(pos: Vector2) -> Area2D:
	return _get_area_at(pos, 8)

func _is_on_water(pos: Vector2) -> bool:
	var tile_pos: Vector2i = water_layer.local_to_map(water_layer.to_local(pos))
	var has_water_tile = water_layer.get_cell_source_id(tile_pos) != -1
	return has_water_tile and _get_area_at(pos, 8) == null

func _is_touching_home(pos: Vector2) -> bool:
	return home.global_position == pos
	
func _is_touching_end_house(pos: Vector2) -> bool:
	return end_house.global_position == pos
	
func _dismiss_return_menu():
	return_home_menu.visible = false
	
func _return_home():
	get_tree().change_scene_to_packed(load_room)

func die():
	if is_resetting:
		return

	is_resetting = true
	current_log = null
	sprite_2d.texture = texture_dead

	Game.die_lose_money()

	await get_tree().create_timer(0.5).timeout
	reset_position()

func reset_position():
	global_position = Vector2(START_X, START_Y)
	target_position = Vector2(START_X, START_Y)
	sprite_2d.texture = texture_alive
	is_resetting = false

func open_popup():
	pop_up_menu.visible = true
