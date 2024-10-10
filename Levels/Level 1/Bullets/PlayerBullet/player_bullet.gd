extends RigidBody3D

const speed = 25
var time = 0

func _ready() -> void:
	linear_velocity.z = cos(rotation.y) * speed
	linear_velocity.x = sin(rotation.y) * speed

func _process(delta: float) -> void:
	time += delta
	if(time > 2):
		queue_free()
	
	if(get_colliding_bodies()):
		queue_free()
