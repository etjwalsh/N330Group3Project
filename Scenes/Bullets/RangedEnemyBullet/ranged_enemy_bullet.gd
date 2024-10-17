extends RigidBody3D

@export var bulletSpeed = 25
var time = 0
var damage = 1

func _physics_process(delta: float) -> void:
	position.z += cos(rotation.y) * delta * bulletSpeed
	position.x += sin(rotation.y) * delta * bulletSpeed
	
	time += delta
	if(time > 2):
		queue_free()
	
	var bodies = get_colliding_bodies()
	if(bodies):
		for i in bodies:
			if("health" in i):
				i.health -= damage
		queue_free()
