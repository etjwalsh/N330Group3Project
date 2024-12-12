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

var move_direction = 135
var anim_direction = "rt"
var animation = "hoverMove"

enum {still, circleLeft, circleRight}

const bullet = preload("res://Scenes/Bullets/RangedEnemyBullet/RangedEnemyBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("roboEnemy2_Shoot1/AnimationPlayer").play("hoverMove")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#advances timer
	time += delta
	
	#stops shooting if currently being hit by the player's sword
	if(swordHit):
		hitstunTimer += delta
		if(hitstunTimer > hitstun):
			swordHit = false
			hitstunTimer = 0
	
	#despawn if health zero
	if(health <= 0):
		queue_free()
	
	#spawn a bunch of bullets aimed at the player in a spread pattern
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
	
	#the AI mode is decided at random between three modes every time the time rolls over
	if(fmod(time, moveUpdate) < fmod(prevTime, moveUpdate)):
		aiMode = randi() % 3
	
	#based on the AImode this code executes how the enemy should act. "still" means the enemy is
	#not moving, circle right makes the guy circle to the right of the player and circle left
	#makes the guy circle to the left of the player
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
				#move_direction = rad_to_deg(temp.angle())
		circleRight:
			if(swordHit):
				aiMode = still
			else:
				var temp = PlayerAutoload.pos.direction_to(position)
				temp = Vector2(temp.x, temp.z).rotated(-PI/2)
				linear_velocity = Vector3(temp.x, 0, temp.y) * delta * speed
				#move_direction = rad_to_deg(temp.angle())
	
	#Animate_loop()
	
	#gives the time to the prevtime variable
	prevTime = time

#func Animate_loop():
	#print(move_direction)
	#if((move_direction>90)||(move_direction<-90&&move_direction>-90)):
	#	$roboEnemy2_Shoot1.global_scale(Vector3(1,1,1))
	#else :
	#	$roboEnemy2_Shoot1.global_scale(Vector3(-1,-1,-1))
	#get_node("roboEnemy2_Shoot1/AnimationPlayer").play("hoverMove")
