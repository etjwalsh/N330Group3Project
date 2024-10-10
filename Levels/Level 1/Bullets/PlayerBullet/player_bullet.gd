extends Sprite3D

const speed = 25
var time = 0

func _physics_process(delta: float) -> void:
	position.z += cos(rotation.y) * delta * speed
	position.x += sin(rotation.y) * delta * speed
	
	time += delta
	if(time > 2):
		queue_free()
