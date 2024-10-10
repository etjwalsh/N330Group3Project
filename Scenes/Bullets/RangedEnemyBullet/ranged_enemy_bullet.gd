extends RigidBody3D

var bulletSpeed = 25
var time = 0

func _physics_process(delta: float) -> void:
	position.z += cos(rotation.y) * delta * bulletSpeed
	position.x += sin(rotation.y) * delta * bulletSpeed
	
	time += delta
	if(time > 2):
		queue_free()
