extends CharacterBody2D


@onready var sprite_2d: Sprite2D = $Sprite2D
const GRID_SIZE: int = 32
const MOVE_TWEEN_DURATION: float = 0.1
const START_POS: Vector2 = Vector2(624.0, 704.0)

var target_position: Vector2  = Vector2.ZERO

var is_moving: bool = false
var is_resetting: bool = false
var is_in_water: bool = false

var current_water_obstacle: Node2D = null
var move_tween: Tween = null

func _ready():
	target_position = global_position

func _process(_delta):
	if (is_moving || is_resetting):
		return
	var input_dir: Vector2 = _get_input_direction()
	if (input_dir != Vector2.ZERO):
		var new_position: Vector2 = (global_position + input_dir * GRID_SIZE)
		_start_move_to(new_position)
		global_position = global_position.snapped(Vector2(GRID_SIZE, GRID_SIZE))

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
	
func _start_move_to(move_position: Vector2):
	is_moving = true
	target_position = move_position
	move_tween = create_tween()
	move_tween.tween_property(self, "global_position", target_position, MOVE_TWEEN_DURATION)
	move_tween.finished.connect(_on_move_tween_complete)


func _on_move_tween_complete():
	is_moving = false
