
	
extends Control

@onready var load_room = preload("res://src/design/world/design_world.tscn")
@onready var load_bugger = preload("res://src/bugger/levels/bugger_1.tscn")

@onready var main_menu: MarginContainer = $MainMenu
@onready var start_game: Button = $MainMenu/VBoxContainer/MarginContainer/StartGame
@onready var credits: Button = $MainMenu/VBoxContainer/MarginContainer2/Credits
@onready var settings: Button = $MainMenu/VBoxContainer/MarginContainer3/Settings

func _ready():
	start_game.pressed.connect(_start_game)

func _start_game():
	get_tree().change_scene_to_packed(load_bugger)
	
