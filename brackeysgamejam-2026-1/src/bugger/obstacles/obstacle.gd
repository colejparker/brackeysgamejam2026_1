extends Area2D

@export var sprite_texture: Texture2D
@export_enum("Left", "Right", "Up", "Down") var direction: String = "Right"
@export var speed: float = 64.0
@export var is_lethal: bool = true
@export var is_water_safe: bool = false

@export var boundary_left: float = 0.0
@export var boundary_right: float = 0.0
@export var boundary_top: float = 0.0
@export var boundary_bottom: float = 0.0
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var enemy: Area2D = $"."

var velocity: Vector2 = Vector2.ZERO
var _accumulated_distance: float = 0.0
const GRID_SIZE: int = 32

func _ready():
	if sprite_texture != null and has_node("Sprite2D"):
		sprite_2d.texture = sprite_texture

	if is_water_safe:
		collision_layer = 8
	elif is_lethal:
		collision_layer = 2
	else:
		collision_layer = 4
	collision_mask = 1

	match direction:
		"Left":
			velocity = Vector2.LEFT * speed
			enemy.rotation_degrees = 270
		"Right":
			velocity = Vector2.RIGHT * speed
			enemy.rotation_degrees = 90
		"Up":
			velocity = Vector2.UP * speed
			enemy.rotation_degrees = 0
		"Down":
			velocity = Vector2.DOWN * speed
			enemy.rotation_degrees = 180

	body_entered.connect(_on_body_entered)
	
func _process(_delta: float) -> void:
	if (speed > 0.0):
		if direction == "Right" or direction == "Left":
			if global_position.x < boundary_left or global_position.x > boundary_right:
				queue_free()
		else:
			if global_position.y < boundary_top or global_position.y > boundary_bottom:
				queue_free()

func _physics_process(delta):
	if is_water_safe:
		_accumulated_distance += speed * delta
		if _accumulated_distance >= GRID_SIZE:
			_accumulated_distance -= GRID_SIZE
			global_position += velocity.normalized() * GRID_SIZE
			global_position = global_position.snapped(Vector2(GRID_SIZE, GRID_SIZE))
	else:
		global_position += velocity * delta

func _on_body_entered(body: Node2D):
	if is_lethal and body.has_method("die"):
		body.die()		
