extends PanelContainer

@export var furniture_data: FurnitureData
@export var is_active: bool = false
@onready var sprite = $Sprite2D
@onready var active_slot = $ActiveSlot

func _ready() -> void:
	update_for_change()

func update_for_change() -> void:
	if furniture_data != null:
		sprite.texture = furniture_data.texture
		sprite.hframes = 2 if furniture_data.is_wall else 4
		sprite.frame = 0
	else:
		sprite.texture = null
	active_slot.visible = is_active
