extends Node2D

@export var obstacle_scene: PackedScene
@export_enum("Left", "Right", "Up", "Down") var spawn_direction: String = "Right"
@export var spawn_interval: float = 2.0
@export var obstacle_speed: float = 64.0

@export_group("Boundaries")
@export var boundary_left: float = 0.0
@export var boundary_right: float = 0.0
@export var boundary_top: float = 0.0
@export var boundary_bottom: float = 0.0

@onready var spawn_timer: Timer = $Timer

func _ready():
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()
	call_deferred("_spawn_obstacle")

func _on_spawn_timer_timeout():
	_spawn_obstacle()

func _spawn_obstacle():
	var obstacle = obstacle_scene.instantiate()

	obstacle.direction = spawn_direction
	obstacle.speed = obstacle_speed
	obstacle.boundary_left = boundary_left
	obstacle.boundary_right = boundary_right
	obstacle.boundary_top = boundary_top
	obstacle.boundary_bottom = boundary_bottom

	obstacle.position = global_position
	get_parent().add_child(obstacle)
