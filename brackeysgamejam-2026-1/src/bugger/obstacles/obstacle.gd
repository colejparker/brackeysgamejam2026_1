extends Area2D

@export var sprite_texture: Texture2D
@export_enum("Left", "Right", "Up", "Down") var direction: String = "Right"
@export var speed: float = 64.0
@export var is_lethal: bool = true

var velocity: Vector2 = Vector2.ZERO

func _ready():
	if sprite_texture != null and has_node("Sprite2D"):
		$Sprite2D.texture = sprite_texture

	if is_lethal:
		collision_layer = 2
		add_to_group("enemies")
	else:
		collision_layer = 4 
		add_to_group("obstacles")
		

	collision_mask = 1

	match direction:
		"Left":
			velocity = Vector2.LEFT * speed
		"Right":
			velocity = Vector2.RIGHT * speed
		"Up":
			velocity = Vector2.UP * speed
		"Down":
			velocity = Vector2.DOWN * speed

	body_entered.connect(_on_body_entered)
	
func _process(delta: float) -> void:
	#To-Do: If outside limits, free_queue
	return

func _physics_process(delta):
	global_position += velocity * delta

func _on_body_entered(body: Node2D):
	if is_lethal and body.has_method("die"):
		body.die()		
