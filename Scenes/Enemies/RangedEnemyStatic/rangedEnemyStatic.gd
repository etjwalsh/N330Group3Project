extends RigidBody3D

const bulletNum = 8
const spread = .1
const bulletSpreadDist = .5
const bulletSpeed = 15
const bulletTimer = 1.5
const hitstun = 1
const moveUpdate = 1
const speed = 2
const turnTimerMax = 3

var health = 5
var time = 0
var prevTime = 0
var enemyBulletIns
var swordHit = false
var hitstunTimer = 0
var aiMode = still
var turnTime = 0

var move_direction = 135
var anim_direction = "rt"
var animation = "jumpWalk"

enum {still, move}


const bullet = preload("res://Scenes/Bullets/RangedEnemyBullet/RangedEnemyBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$EnemySprite.modulate = Color(1, .44, .45)
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
	
	#shoots bullets in a circle
	if(time >= bulletTimer):
		time = 0
		if(!swordHit):
			for i in bulletNum:
				enemyBulletIns = bullet.instantiate()
				enemyBulletIns.rotation.y = PI/4 * i
				enemyBulletIns.bulletSpeed = bulletSpeed
				add_child(enemyBulletIns)
	
	#waits for the turn timer to get triggered and potentially turns to one of the four cardinal directions.
	if(turnTime < 0):
		turnTime = randf() * turnTimerMax
		if(randi() % 2):
			aiMode = move
			var vect2 = Vector2.from_angle(randf() * PI/2) * speed
			linear_velocity = Vector3(vect2.x, 0, vect2.y)
			#move_direction = rad_to_deg(vect2.angle())
		else:
			aiMode = still
	else:
		turnTime -= delta
	
	#if the aiMode is still, don't move
	match(aiMode):
		still:
			linear_velocity = Vector3.ZERO
	
	#Animate_loop()
	
	#gives the time to the prevtime variable
	prevTime = time

#func Animate_loop():
	#if(move_direction>90):
		#$roboEnemy1_Circle.global_scale(Vector3(1,1,1))
	#else :
		#$roboEnemy1_Circle.global_scale(Vector3(-1,1,1))
	#get_node("roboEnemy1_Circle/AnimationPlayer").play("jumpWalk")
