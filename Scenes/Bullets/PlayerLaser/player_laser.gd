extends RigidBody3D

const damage = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#finds the location between its start and the first bit of collision in the direction of the pointer
	if($RayCast3D.is_colliding()):
		$Sprite3D.scale.y = global_position.distance_to($RayCast3D.get_collision_point()) * 3
		$CollisionShape3D.scale.y = global_position.distance_to($RayCast3D.get_collision_point()) * 3
		$Sprite3D.position.z = global_position.distance_to($RayCast3D.get_collision_point()) * 48 / 100
		$CollisionShape3D.position.z = global_position.distance_to($RayCast3D.get_collision_point()) * 48 / 100
		var collider = $RayCast3D.get_collider()
		
		#constantly hurt the enemy if its hitting an enemy
		if("health" in collider):
			collider.health -= delta * damage
	else:
		#this prevents it from going infinitly
		$Sprite3D.scale.y = 100
		$CollisionShape3D.scale.y = 100
		$Sprite3D.position.z = 16
		$CollisionShape3D.position.z = 16
