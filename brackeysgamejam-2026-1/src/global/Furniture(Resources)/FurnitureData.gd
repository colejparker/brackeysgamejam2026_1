class_name FurnitureData
extends Resource

enum SizeConfig {
	ONE_BY_ONE,
	TWO_BY_ONE
}

@export var is_wall: bool
@export var name: String
@export var texture: Texture2D
@export var size_config: SizeConfig = SizeConfig.ONE_BY_ONE
