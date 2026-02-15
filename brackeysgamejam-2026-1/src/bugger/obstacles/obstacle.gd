extends Area2D

@export_enum("Left", "Right", "Up", "Down") var direction: String = "Right"
@export var speed: float = 64.0

var velocity: Vector2 = Vector2.ZERO

func _ready():
	collision_layer = 2
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
	if body.has_method("die"):
		body.die()
		
