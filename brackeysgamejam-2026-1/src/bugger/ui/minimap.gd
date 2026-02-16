extends Control

@export var player: Node2D
@export var endItem: Node2D
@export var home: Node2D
@export var map_size: Vector2 = Vector2(120, 100)
@export var world_size: Vector2 = Vector2(640, 360)

@onready var player_indicator: ColorRect = $Panel/PlayerIndicator
@onready var end_indicator: ColorRect = $Panel/EndIndicator
@onready var home_indicator: ColorRect = $Panel/HomeIndicator

func _ready():
	size = map_size

func _process(_delta):
	if player == null:
		return

	var player_percent_x = player.global_position.x / world_size.x
	var player_percent_y = player.global_position.y / world_size.y
	
	var end_percent_x = endItem.global_position.x / world_size.x
	var end_percent_y = endItem.global_position.y / world_size.y
	
	var home_percent_x = home.global_position.x / world_size.x
	var home_percent_y = home.global_position.y / world_size.y

	var player_x = player_percent_x * map_size.x
	var player_y = player_percent_y * map_size.y

	player_indicator.position = Vector2(player_x - 2, player_y - 2)
	
	var end_x = end_percent_x * map_size.x
	var end_y = end_percent_y * map_size.y

	end_indicator.position = Vector2(end_x - 2, end_y - 2)
	
	var home_x = home_percent_x * map_size.x
	var home_y = home_percent_y * map_size.y

	home_indicator.position = Vector2(home_x - 2, home_y - 2)
