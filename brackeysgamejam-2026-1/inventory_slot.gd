extends PanelContainer

@export var furniture_data: FurnitureData
@export var is_active: bool = false
@export var slot_id: int = -1
@onready var sprite = $Sprite2D
@onready var active_slot = $ActiveSlot
@onready var button = $Button

func _ready() -> void:
	update_for_change()
	button.button_up.connect(_on_pressed_button)

func update_for_change() -> void:
	if furniture_data != null:
		sprite.texture = furniture_data.texture
		sprite.hframes = 2 if furniture_data.is_wall else 4
		sprite.frame = 0
	else:
		sprite.texture = null
	active_slot.visible = is_active

func _on_pressed_button() -> void:
	if slot_id >= 0:
		Game.selected_inventory_slot = slot_id
		Game.inventory_updated.emit()
