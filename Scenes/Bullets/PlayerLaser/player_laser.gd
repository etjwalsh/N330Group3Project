extends RigidBody3D

const damage = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if($RayCast3D.is_colliding()):
		$Sprite3D.scale.y = global_position.distance_to($RayCast3D.get_collision_point()) * 3
		$CollisionShape3D.scale.y = global_position.distance_to($RayCast3D.get_collision_point()) * 3
		$Sprite3D.position.z = global_position.distance_to($RayCast3D.get_collision_point()) * 48 / 100
		$CollisionShape3D.position.z = global_position.distance_to($RayCast3D.get_collision_point()) * 48 / 100
		var collider = $RayCast3D.get_collider()
		if("health" in collider):
			collider.health -= delta * damage
	else:
		$Sprite3D.scale.y = 100
		$CollisionShape3D.scale.y = 100
		$Sprite3D.position.z = 16
		$CollisionShape3D.position.z = 16
