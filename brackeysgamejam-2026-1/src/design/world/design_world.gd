extends Node2D

var furniture_scene: PackedScene = preload("res://src/design/furniture/furniture.tscn")
@onready var pop_up_menu: CanvasLayer = $"PopUp Menu"

func _ready() -> void:
	if Game.first_time_in_room:
		Game.first_time_in_room = false
		pop_up_menu.visible = true
	for entry in Game.room.values():
		create_furniture_from_room_entry(entry)

func create_furniture_from_room_entry(room_entry: RoomEntry):
	var furniture = furniture_scene.instantiate()
	furniture.furniture_data = room_entry.furniture
	furniture.position = room_entry.location
	furniture.name = room_entry.name
	furniture.starting_frame = room_entry.frame
	%DecorationLayer.add_child(furniture)
