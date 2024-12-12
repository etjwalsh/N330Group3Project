extends RigidBody3D

const maxTime = 3

@export var bulletSpeed = 25
var time = 0
var damage = 1

func _physics_process(delta: float) -> void:
	#moves in the direction that it is pointing and despawns itself if it lasts too long
	position.z += cos(rotation.y) * delta * bulletSpeed
	position.x += sin(rotation.y) * delta * bulletSpeed
	time += delta
	if(time > maxTime):
		queue_free()

#if the bullet touches something, despawn it. If the body it enters is the player with the health
#field, trigger the hurt function.
func _on_body_entered(body: Node) -> void:
	if("health" in body):
		body.hurt()
	queue_free()
