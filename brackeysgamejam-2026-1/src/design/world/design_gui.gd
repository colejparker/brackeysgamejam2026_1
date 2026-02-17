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
		current_shake = shake_amount
		return
	var furniture_data = Game.inventory[Game.selected_inventory_slot]
	var proposed_position = get_place_position()
	if !can_place(furniture_data, proposed_position):
		current_shake = shake_amount
		return
	
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
	
func can_place(furniture_data: FurnitureData, proposed_position: Vector2) -> bool:
	const BOX_VECTOR_OFFSET = 8
	const BOX_VECTORS = [Vector2(-BOX_VECTOR_OFFSET, -BOX_VECTOR_OFFSET), Vector2(-BOX_VECTOR_OFFSET, BOX_VECTOR_OFFSET), Vector2(BOX_VECTOR_OFFSET, BOX_VECTOR_OFFSET), Vector2(BOX_VECTOR_OFFSET, -BOX_VECTOR_OFFSET)]
	var boxed_points = [proposed_position, proposed_position + BOX_VECTORS[0], proposed_position + BOX_VECTORS[1], proposed_position + BOX_VECTORS[2], proposed_position + BOX_VECTORS[3]]
	for point in boxed_points:
		if !furniture_data.is_wall and !Geometry2D.is_point_in_polygon(point, %FloorPolygon.polygon):
			return false
		if furniture_data.is_wall and !Geometry2D.is_point_in_polygon(point, %WallPolygon.polygon):
			return false
		for child in %DecorationLayer.get_children():
			if !child.is_class("CharacterBody2D"):
				continue
			if child.point_in_rect(point - child.position):
				return false
	return true
