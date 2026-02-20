extends Node2D

var furniture_scene: PackedScene = preload("res://src/design/furniture/furniture.tscn")
@onready var pop_up_menu: CanvasLayer = $"PopUp Menu"
@onready var help_button: TextureButton = $DesignGUI/HelpButton
@onready var wall: ColorRect = $Wall

func _ready() -> void:
	if Game.first_time_in_room:
		Game.first_time_in_room = false
		pop_up_menu.visible = true
	for entry in Game.room.values():
		create_furniture_from_room_entry(entry)
	help_button.pressed.connect(open_popup)
	wall.color = Game.wall_color

func create_furniture_from_room_entry(room_entry: RoomEntry):
	var furniture = furniture_scene.instantiate()
	furniture.furniture_data = room_entry.furniture
	furniture.position = room_entry.location
	furniture.name = room_entry.name
	furniture.starting_frame = room_entry.frame
	%DecorationLayer.add_child(furniture)

func open_popup():
	pop_up_menu.visible = true
