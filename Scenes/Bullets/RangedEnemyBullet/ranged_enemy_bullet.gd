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


func _on_body_entered(body: Node) -> void:
	if("health" in body):
		body.health -= damage
	queue_free()
