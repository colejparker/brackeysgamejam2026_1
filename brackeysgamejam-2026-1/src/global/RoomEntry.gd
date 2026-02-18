class_name RoomEntry
extends Resource

var name: String
var furniture: FurnitureData
var location: Vector2
var frame: int

func initialize(new_name: String, new_furniture: FurnitureData, new_location: Vector2, new_frame: int) -> RoomEntry:
	name = new_name
	furniture = new_furniture
	location = new_location
	frame = new_frame
	return self
