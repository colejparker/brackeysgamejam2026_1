extends CanvasLayer

@onready var inventory_slot = $InventorySlot
@onready var place_button = $PlaceButton

func _ready():
	update_with_inventory()
	Game.inventory_updated.connect(update_with_inventory)
	inventory_slot.button.button_up.connect(open_inventory)
	place_button.button_up.connect(place)

func update_with_inventory() -> void:
	inventory_slot.furniture_data = Game.inventory[Game.selected_inventory_slot] if Game.selected_inventory_slot < Game.inventory.size() else null
	inventory_slot.update_for_change()

func open_inventory():
	%InventoryUI.visible = true

func place():
	if Game.selected_inventory_slot >= Game.inventory.size():
		return
	var furniture_data = Game.inventory[Game.selected_inventory_slot]
	var packed_scene = preload("res://src/design/furniture/furniture.tscn").instantiate()
	packed_scene.furniture_data = furniture_data
	packed_scene.position = Vector2(200.0, 200.0)
	%DecorationLayer.add_child(packed_scene)
	Game.remove_item_from_inventory.emit(furniture_data.name)
