extends RigidBody3D

const sword = preload("res://Scenes/Bullets/EnemySword/enemy_sword.tscn")

const swordTimer = 1.5
const hitstun = 1
const moveUpdate = .5
const speed = 10
const swingDist = 3
const windup = .5

var health = 5
var time = moveUpdate
var prevTime = 0
var enemyBulletIns
var swordHit = false
var hitstunTimer = 0
var aiMode = still

enum {still, charge, attack, swing}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("roboEnemy4_Melee/AnimationPlayer").play("hobbleWalk")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#if the enemy has been hit by the player's sword, prevent them from swinging
	if(swordHit):
		hitstunTimer += delta
		if(hitstunTimer > hitstun):
			swordHit = false
			hitstunTimer = 0
	
	#despawn if health zero
	if(health <= 0):
		queue_free()
	
	#matches the AI mode with what the AI should do. Stay still if "still", charge toward the player
	#if "charge", be swinging if "swing"
	match(aiMode):
		still:
			time -= delta
			if(time <= 0):
				aiMode = charge
			linear_velocity = Vector3.ZERO
		charge:
			if(swordHit):
				aiMode = still
				time = moveUpdate
				linear_velocity = Vector3.ZERO
			else:
				if(abs(position - PlayerAutoload.pos).length() > swingDist):
					var dist = position.direction_to(PlayerAutoload.pos) * speed
					dist.y = 0
					linear_velocity = dist
				else:
					linear_velocity = Vector3.ZERO
					aiMode = attack
					time = windup
		attack:
			if(swordHit):
				aiMode = still
				time = moveUpdate
				linear_velocity = Vector3.ZERO
			else:
				time -= delta
				if(time <= 0):
					aiMode = swing
				else:
					linear_velocity = Vector3.ZERO
		swing:
			if(!is_instance_valid(enemyBulletIns)):
				enemyBulletIns = sword.instantiate()
				var direction = position.direction_to(PlayerAutoload.pos)
				enemyBulletIns.rotation.y = -Vector2(direction.x, direction.z).angle() + PI/2
				enemyBulletIns.position.y += .5
				add_child(enemyBulletIns)
				aiMode = still
				time = moveUpdate
	
	#makes the timer tracking the previous time marker track the previous time marker.
	prevTime = time
