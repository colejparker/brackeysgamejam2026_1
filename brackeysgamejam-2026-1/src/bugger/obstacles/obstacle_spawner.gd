extends Node2D

@export var obstacle_scene: PackedScene
@export_enum("Left", "Right", "Up", "Down") var spawn_direction: String = "Right"
@export var spawn_interval: float = 2.0
@export var obstacle_speed: float = 64.0

@onready var spawn_timer: Timer = $Timer

func _ready():
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _on_spawn_timer_timeout():
	_spawn_obstacle()

func _spawn_obstacle():
	var obstacle = obstacle_scene.instantiate()

	obstacle.global_position = global_position

	obstacle.direction = spawn_direction
	obstacle.speed = obstacle_speed

	get_parent().add_child(obstacle)
