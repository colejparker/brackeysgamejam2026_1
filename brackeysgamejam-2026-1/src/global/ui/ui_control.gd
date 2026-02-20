
	
extends Control

@onready var load_room = preload("res://src/design/world/design_world.tscn")

@onready var main_menu: MarginContainer = $MainMenu
@onready var start_game: Button = $MainMenu/MarginContainer/VBoxContainer/MarginContainer/StartGame
@onready var credits: Button = $MainMenu/MarginContainer/VBoxContainer/MarginContainer2/Credits
@onready var settings: Button = $MainMenu/MarginContainer/VBoxContainer/MarginContainer3/Settings


var settings_menu: PackedScene = preload("res://src/global/ui/settings.tscn")
var credits_menu: PackedScene = preload("res://src/global/ui/credits.tscn")
const WALK = preload("uid://dbj0nhfjsue07")


func _ready():
	start_game.pressed.connect(_start_game)
	settings.pressed.connect(_settings)
	credits.pressed.connect(_credits)

func _start_game():
	SoundFxPlayer._play_sound(WALK)
	get_tree().change_scene_to_packed(load_room)
	
func _settings():
	SoundFxPlayer._play_sound(WALK)
	var settings_node = settings_menu.instantiate()
	get_tree().current_scene.add_child(settings_node)
	
func _credits():
	SoundFxPlayer._play_sound(WALK)
	var credits_node = credits_menu.instantiate()
	get_tree().current_scene.add_child(credits_node)
	
