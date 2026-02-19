
	
extends Control

@onready var load_room = preload("res://src/design/world/design_world.tscn")

@onready var main_menu: MarginContainer = $MainMenu
@onready var start_game: Button = $MainMenu/VBoxContainer/MarginContainer/StartGame
@onready var credits: Button = $MainMenu/VBoxContainer/MarginContainer2/Credits
@onready var settings: Button = $MainMenu/VBoxContainer/MarginContainer3/Settings

var settings_menu: PackedScene = preload("res://src/global/ui/settings.tscn")

func _ready():
	start_game.pressed.connect(_start_game)
	settings.pressed.connect(_settings)

func _start_game():
	get_tree().change_scene_to_packed(load_room)
	
func _settings():
	var settings_node = settings_menu.instantiate()
	get_tree().current_scene.add_child(settings_node)
	
