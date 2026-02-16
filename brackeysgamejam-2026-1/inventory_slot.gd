extends PanelContainer

@export var furniture_data: FurnitureData
@onready var sprite = $Sprite2D

func _ready() -> void:
	if furniture_data:
		sprite.texture = furniture_data.texture
		sprite.hframes = 2 if furniture_data.is_wall else 4
		sprite.frame = 0
	else:
		sprite.texture = null
