extends RigidBody3D

const sword = preload("res://Scenes/Bullets/EnemySword/enemy_sword.tscn")
const bullet = preload("res://Scenes/Bullets/RangedEnemyBullet/RangedEnemyBullet.tscn")
const rangedEnemy = preload("res://Scenes/Enemies/RangedEnemyStatic/ranged_enemy_static.tscn")

var wideshotEnemy = preload("res://Scenes/Enemies/RangedEnemy/rangedEnemy.tscn")
var shotgunEnemy = preload("res://Scenes/Enemies/RangedEnemy2/ranged_enemy_2.tscn")
var staticEnemy = preload("res://Scenes/Enemies/RangedEnemyStatic/ranged_enemy_static.tscn")
var meleeEnemy = preload("res://Scenes/Enemies/MeleeEnemy/MeleeEnemy.tscn")

const maxHealth = 50
const triggerTime = 2
const swingDist = 3
const windup = .5
const bulletNum = 8
const bulletNum2 = 10
const speed = 10
const bulletSpeed = 15
const spread = 1.0
const bulletSpeedMin = 5
const bulletSpreadDist = .5
const bulletNum3 = 5
const spread2 = .1
const bulletSpreadDist2 = .5

@export var health = maxHealth
var phase = 0
var pattern = 0
var time = 0
var prevTime = 0
var executing = 0
var aiMode = 0
var enemySwordIns
var enemyBulletIns
var enemyToSpawn
var spawnPos = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#despawn if health zero
	if(health <= 0):
		queue_free()
	
	match(executing):
		0:
			time += delta
			if(time > triggerTime):
				time = 0
				if(health < maxHealth / 2):
					phase = 1
				match(phase):
					0:
						match(pattern):
							0:
								executing = 1
								pattern += 1
							1:
								executing = 2
								pattern = 0
					1:
						match(pattern):
							0:
								executing = 3
								pattern += 1
							1:
								executing = 4
								pattern = 0
		1:
			match(aiMode):
				0:
					if(abs(position - PlayerAutoload.pos).length() > swingDist):
						var dist = position.direction_to(PlayerAutoload.pos) * speed
						dist.y = 0
						linear_velocity = dist
					else:
						linear_velocity = Vector3.ZERO
						aiMode = 1
						time = windup
				1:
					time -= delta
					if(time <= 0):
						if(!is_instance_valid(enemySwordIns)):
							enemySwordIns = sword.instantiate()
							var direction = position.direction_to(PlayerAutoload.pos)
							enemySwordIns.rotation.y = -Vector2(direction.x, direction.z).angle() + PI/2
							enemySwordIns.position.y += .5
							add_child(enemySwordIns)
							executing = 0
							aiMode = 0
							for i in bulletNum:
								enemyBulletIns = bullet.instantiate()
								enemyBulletIns.rotation.y = PI/4 * i
								enemyBulletIns.bulletSpeed = bulletSpeed
								add_child(enemyBulletIns)
						time = 0
					else:
						linear_velocity = Vector3.ZERO
		2:
			var dir = -Vector2(position.x, position.z).angle_to_point(Vector2(PlayerAutoload.pos.x, PlayerAutoload.pos.z)) + PI/2
			for i in bulletNum2:
				enemyBulletIns = bullet.instantiate()
				enemyBulletIns.rotation.y = dir + ((randf() * spread) - (spread / 2))
				enemyBulletIns.bulletSpeed = bulletSpeedMin + (bulletSpeed * randf())
				enemyBulletIns.position += enemyBulletIns.basis.x * ((randf() * bulletSpreadDist) - (bulletSpreadDist / 2))
				add_child(enemyBulletIns)
			executing = 0
			aiMode = 0
		3:
			match int(randi_range(0,3)):
				0:
					enemyToSpawn = wideshotEnemy.instantiate()
				1:
					enemyToSpawn = shotgunEnemy.instantiate()
				2:
					enemyToSpawn = staticEnemy.instantiate()
				3:
					enemyToSpawn = meleeEnemy.instantiate()
			enemyToSpawn.position.y = .5
			add_child(enemyToSpawn)
			executing = 0
			aiMode = 0
		4:
			match(aiMode):
				0:
					print(abs(position - PlayerAutoload.pos).length())
					print(swingDist)
					if(abs(position - PlayerAutoload.pos).length() > swingDist):
						var dist = position.direction_to(PlayerAutoload.pos) * speed
						dist.y = 0
						linear_velocity = dist
					else:
						linear_velocity = Vector3.ZERO
						aiMode = 1
						time = windup
				1:
					time -= delta
					if(time <= 0):
						if(!is_instance_valid(enemySwordIns)):
							enemySwordIns = sword.instantiate()
							var direction = position.direction_to(PlayerAutoload.pos)
							enemySwordIns.rotation.y = -Vector2(direction.x, direction.z).angle() + PI/2
							enemySwordIns.position.y += .5
							add_child(enemySwordIns)
							executing = 0
							aiMode = 0	
							var dir = -Vector2(position.x, position.z).angle_to_point(Vector2(PlayerAutoload.pos.x, PlayerAutoload.pos.z)) + PI/2
							for i in bulletNum3:
								enemyBulletIns = bullet.instantiate()
								enemyBulletIns.rotation.y = dir + ((i - floor(bulletNum3 / 2)) * spread2)
								enemyBulletIns.bulletSpeed = bulletSpeed
								enemyBulletIns.position += enemyBulletIns.basis.z * (1 - (abs((bulletNum3 / 2) - i))) * bulletSpreadDist2
								enemyBulletIns.position += enemyBulletIns.basis.x * (i - floor(bulletNum3 / 2.0)) * bulletSpreadDist2
								add_child(enemyBulletIns)
						time = 0
					else:
						linear_velocity = Vector3.ZERO
