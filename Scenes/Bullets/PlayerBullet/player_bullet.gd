extends Sprite3D

const speed = 25
const timeLim = 2

var time = 0

func _physics_process(delta: float) -> void:
	#goes in the direction it is facing
	position.z += cos(rotation.y) * delta * speed
	position.x += sin(rotation.y) * delta * speed
	time += delta
	if(time > timeLim):
		queue_free()
