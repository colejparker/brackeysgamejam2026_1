extends CanvasLayer

const INVSIZE = 18
const inv_slot_scene = preload("res://src/design/world/inventory_slot.tscn")

func _ready():
	for i in range(INVSIZE):
		var slot := inv_slot_scene.instantiate()
		%Inv.add_child(slot)

func update_with_inventory(list_of_items: Array[FurnitureData]) -> void:
	pass
