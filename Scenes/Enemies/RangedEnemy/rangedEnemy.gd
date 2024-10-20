extends RigidBody3D

const bulletNum = 5
const spread = .1
const bulletSpreadDist = .5
const bulletSpeed = 15
const bulletTimer = 1.5
const hitstun = 1
const moveUpdate = 1
const speed = 200

var health = 5
var time = 0
var prevTime = 0
var enemyBulletIns
var swordHit = false
var hitstunTimer = 0
var aiMode = still

enum {still, circleLeft, circleRight}

const bullet = preload("res://Scenes/Bullets/RangedEnemyBullet/RangedEnemyBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EnemySprite.modulate = Color(1, .44, .45)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	time += delta
	
	if(swordHit):
		hitstunTimer += delta
		if(hitstunTimer > hitstun):
			swordHit = false
			hitstunTimer = 0
	
	#despawn if health zero
	if(health <= 0):
		queue_free()
	if(time >= bulletTimer):
		time = 0
		if(!swordHit):
			var dir = -Vector2(position.x, position.z).angle_to_point(Vector2(PlayerAutoload.pos.x, PlayerAutoload.pos.z)) + PI/2
			for i in bulletNum:
				enemyBulletIns = bullet.instantiate()
				enemyBulletIns.rotation.y = dir + ((i - floor(bulletNum / 2)) * spread)
				enemyBulletIns.bulletSpeed = bulletSpeed
				enemyBulletIns.position += enemyBulletIns.basis.z * (1 - (abs((bulletNum / 2) - i))) * bulletSpreadDist
				enemyBulletIns.position += enemyBulletIns.basis.x * (i - floor(bulletNum / 2.0)) * bulletSpreadDist
				add_child(enemyBulletIns)
	
	if(fmod(time, moveUpdate) < fmod(prevTime, moveUpdate)):
		aiMode = randi() % 3
	
	match(aiMode):
		still:
			linear_velocity = Vector3.ZERO
		circleLeft:
			if(swordHit):
				aiMode = still
			else:
				var temp = PlayerAutoload.pos.direction_to(position)
				temp = Vector2(temp.x, temp.z).rotated(PI/2)
				linear_velocity = Vector3(temp.x, 0, temp.y) * delta * speed
		circleRight:
			if(swordHit):
				aiMode = still
			else:
				var temp = PlayerAutoload.pos.direction_to(position)
				temp = Vector2(temp.x, temp.z).rotated(-PI/2)
				linear_velocity = Vector3(temp.x, 0, temp.y) * delta * speed
	
	prevTime = time
