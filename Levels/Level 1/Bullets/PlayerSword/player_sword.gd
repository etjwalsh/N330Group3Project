extends Node3D

const ROTATION_LIMIT = PI/4
const ROTATION_SPEED = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite3D.scale *= 4
	$AnimatedSprite3D.position.z = 2

func _process(delta: float) -> void:
	rotation.y += ROTATION_SPEED * delta
	if(rotation.y > ROTATION_LIMIT):
		rotation.y -= 2 * ROTATION_LIMIT
