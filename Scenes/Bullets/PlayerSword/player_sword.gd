extends RigidBody3D

const ROTATION_LIMIT = PI/4
const ROTATION_SPEED = 5
const damage = 2

var hits = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#scales the sword properly
	$AnimatedSprite3D.scale *= 4
	$AnimatedSprite3D.position.z = 2
	$CollisionShape3D.scale *= 4
	$CollisionShape3D.position.z = 2

func _process(delta: float) -> void:
	#rotates the sword and disables the enemies it hits by changing a boolean
	rotation.y += ROTATION_SPEED * delta
	if(rotation.y > ROTATION_LIMIT):
		get_parent().queue_free()
	
	var bodies = get_colliding_bodies()
	if(bodies):
		for i in bodies:
			var hit = false
			for j in hits:
				if j == i:
					hit = true
			if(!hit):
				if "health" in i:
					hits.append(i)
					i.health -= damage
					i.swordHit = true
