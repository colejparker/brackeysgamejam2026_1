extends PanelContainer

@export var furniture_data: FurnitureData
@export var is_active: bool = false
@export var slot_id: int = -1
@onready var sprite = $Sprite2D
@onready var frame_sprite = $Frame
@onready var active_slot = $ActiveSlot
@onready var button_left = $ButtonLeft

func _ready() -> void:
	update_for_change()

func update_for_change() -> void:
	if furniture_data != null:
		sprite.texture = furniture_data.texture
		sprite.hframes = 2 if furniture_data.is_wall else 4
		sprite.frame = 0
		sprite.scale = Vector2(0.75, 0.75) if sprite.texture.get_height() > 64 else Vector2(1,1)
		sprite.position = Vector2(50, 43) if furniture_data.size_config == FurnitureData.SizeConfig.TWO_BY_ONE else Vector2(43,43)
	else:
		sprite.texture = null
	active_slot.visible = is_active
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if frame_sprite.get_rect().has_point(frame_sprite.to_local(event.position)):
			if event.button_index == MOUSE_BUTTON_LEFT:
				_on_pressed_button_left()
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				_on_pressed_button_right()

func _on_pressed_button_left() -> void:
	if slot_id >= 0:
		Game.selected_inventory_slot = slot_id
		Game.inventory_updated.emit()

func _on_pressed_button_right() -> void:
	if slot_id >= 0:
		Game.remove_item_from_inventory.emit(furniture_data.name)
