extends Sprite3D

@export var shape:CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.z = 16
	scale.y = 100
	shape.scale.y = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
