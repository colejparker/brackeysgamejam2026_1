extends CanvasLayer

const INVSIZE = 18
const inv_slot_scene = preload("res://src/design/world/inventory_slot.tscn")

@onready var inv = $Inv
@onready var close_button = $CloseButton

var slots = []

func _ready():
	for i in range(INVSIZE):
		var slot := inv_slot_scene.instantiate()
		slot.slot_id = i
		inv.add_child(slot)
		slots.append(slot)
	update_with_inventory()
	Game.inventory_updated.connect(update_with_inventory)
	close_button.button_up.connect(close_inventory)
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		visible = !visible
		
	if Input.is_action_just_pressed("test_action"):
		Game.add_item_to_inventory.emit("Matchbox Bed")

func update_with_inventory() -> void:
	for i in slots.size():
		if i < Game.inventory.size():
			slots[i].furniture_data = Game.inventory[i]
		else:
			slots[i].furniture_data = null
		slots[i].is_active = Game.selected_inventory_slot == i
		slots[i].update_for_change()

func close_inventory() -> void:
	visible = false
