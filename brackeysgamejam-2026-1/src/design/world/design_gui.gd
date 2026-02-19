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
	inventory_slot.button_left.button_up.connect(open_inventory)
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
	var proposed_position = get_place_position(furniture_data)
	if !can_place(furniture_data, proposed_position):
		current_shake = shake_amount
		return
	
	var packed_scene = preload("res://src/design/furniture/furniture.tscn").instantiate()
	packed_scene.furniture_data = furniture_data
	packed_scene.position = proposed_position
	%DecorationLayer.add_child(packed_scene)
	Game.remove_item_from_inventory.emit(furniture_data.name)
	Game.update_item_in_room.emit(packed_scene.name, furniture_data, proposed_position, 0)

func get_place_distance(furniture_data: FurnitureData):
	if furniture_data.is_wall:
		return 100
	var direction = %DesignPlayer.last_direction
	if furniture_data.size_config == FurnitureData.SizeConfig.ONE_BY_ONE:
		return 40 
	if direction.x < -0.1:
		return 50
	if direction.y < -0.1:
		return 40
	return 70
	
func get_place_position(furniture_data: FurnitureData) -> Vector2:
	return %DesignPlayer.position - Vector2(32, 0) + (%DesignPlayer.last_direction) * get_place_distance(furniture_data)
	
func _physics_process(delta: float) -> void:
	current_shake = max(0, current_shake - (shake_amount * delta / shake_duration))
	place_button.position = base_place_button_position + Vector2(randf_range(-current_shake, current_shake), randf_range(-current_shake, current_shake))
	
func can_place(furniture_data: FurnitureData, proposed_position: Vector2) -> bool:
	const BOX_VECTOR_OFFSET = 8
	const BOX_VECTORS = [Vector2(0,0), Vector2(-BOX_VECTOR_OFFSET, -BOX_VECTOR_OFFSET), Vector2(-BOX_VECTOR_OFFSET, BOX_VECTOR_OFFSET), Vector2(BOX_VECTOR_OFFSET, BOX_VECTOR_OFFSET), Vector2(BOX_VECTOR_OFFSET, -BOX_VECTOR_OFFSET)]
	const TWO_BY_ONE_VECTORS = [Vector2(0,0), Vector2(-51, -3), Vector2(-51, 8), Vector2(-19,24), Vector2(31,-5), Vector2(31, -15), Vector2(-1, -31)]
	var boxed_points = []
	match furniture_data.size_config: 
		FurnitureData.SizeConfig.ONE_BY_ONE: boxed_points = BOX_VECTORS.map(func(p): return proposed_position + p)
		FurnitureData.SizeConfig.TWO_BY_ONE: boxed_points = TWO_BY_ONE_VECTORS.map(func(p): return proposed_position + p)
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
