extends CanvasLayer

@onready var inventory_slot = $InventorySlot
@onready var place_button = $PlaceButton
@onready var base_place_button_position = place_button.position


var shake_amount = 5.0
var shake_duration = 1
var current_shake = 0

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
	var proposed_position = get_place_position()
	for child in %DecorationLayer.get_children():
		if child.point_in_rect(proposed_position - child.position):
			current_shake = shake_amount
			return
	var furniture_data = Game.inventory[Game.selected_inventory_slot]
	var packed_scene = preload("res://src/design/furniture/furniture.tscn").instantiate()
	packed_scene.furniture_data = furniture_data
	packed_scene.position = get_place_position()
	%DecorationLayer.add_child(packed_scene)
	Game.remove_item_from_inventory.emit(furniture_data.name)

func get_place_position() -> Vector2:
	return %DesignPlayer.position - Vector2(32, 0) + (%DesignPlayer.last_direction) * 30
	
func _physics_process(delta: float) -> void:
	current_shake = max(0, current_shake - (shake_amount * delta / shake_duration))
	
	place_button.position = base_place_button_position + Vector2(randf_range(-current_shake, current_shake), randf_range(-current_shake, current_shake))
