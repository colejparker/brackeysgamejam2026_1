extends CharacterBody2D


@onready var sprite_2d: Sprite2D = $Sprite2D
const GRID_SIZE: int = 32
@export var START_X: int = 0
@export var START_Y: int = 0

var texture_alive: Texture2D = preload("res://assets/sprites/mainbugguy.png")
var texture_dead: Texture2D = preload("res://assets/sprites/mainbugguy-dead.png")

@onready var load_room = preload("res://src/design/world/design_world.tscn")

var target_position: Vector2  = Vector2.ZERO

var is_resetting: bool = false
@onready var return_home_menu: CanvasLayer = $"../ReturnHomeMenu"
@onready var cancel_return: Button = $"../ReturnHomeMenu/ReturnHomeMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/CancelReturn"
@onready var return_home: Button = $"../ReturnHomeMenu/ReturnHomeMenuBase/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ReturnHome"
@onready var home: Area2D = $"../ObstacleLayer/Home"

func _ready():
	return_home_menu.visible = false
	
	cancel_return.pressed.connect(_dismiss_return_menu)
	return_home.pressed.connect(_return_home)
	
	global_position = global_position.snapped(Vector2(GRID_SIZE, GRID_SIZE))
	target_position = global_position

	collision_layer = 1
	collision_mask = 2 | 4

func _process(_delta):
	if is_resetting:
		return
	var input_dir: Vector2 = _get_input_direction()
	if (input_dir != Vector2.ZERO) and !return_home_menu.visible:
		var new_position: Vector2 = (global_position + input_dir * GRID_SIZE).snapped(Vector2(GRID_SIZE, GRID_SIZE))

		if not _is_position_blocked(new_position):
			global_position = new_position
			target_position = new_position
		elif _is_touching_home(new_position):
			return_home_menu.visible = true

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
	

func _is_position_blocked(pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collision_mask = 4
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var result = space_state.intersect_point(query)
	return result.size() > 0

func _is_touching_home(pos: Vector2) -> bool:
	return home.global_position == pos
	
func _dismiss_return_menu():
	return_home_menu.visible = false
	
func _return_home():
	get_tree().change_scene_to_packed(load_room)

func die():
	if is_resetting:
		return

	is_resetting = true
	sprite_2d.texture = texture_dead

	Game.die_lose_money()

	await get_tree().create_timer(0.5).timeout
	reset_position()

func reset_position():
	global_position = Vector2(START_X, START_Y)
	target_position = Vector2(START_X, START_Y)
	sprite_2d.texture = texture_alive
	is_resetting = false
