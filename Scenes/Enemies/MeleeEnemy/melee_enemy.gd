extends RigidBody3D

const sword = preload("res://Scenes/Bullets/EnemySword/enemy_sword.tscn")

const swordTimer = 1.5
const hitstun = 1
const moveUpdate = 1
const speed = 10
const swingDist = 5

var health = 5
var time = 0
var prevTime = 0
var enemyBulletIns
var swordHit = false
var hitstunTimer = 0
var aiMode = still

enum {still, charge}

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
	
	if(fmod(time, moveUpdate) < fmod(prevTime, moveUpdate)):
		aiMode = charge
	
	match(aiMode):
		still:
			linear_velocity = Vector3.ZERO
		charge:
			if(swordHit):
				aiMode = still
			else:
				if(abs(position - PlayerAutoload.pos).length() > swingDist):
					var dist = position.direction_to(PlayerAutoload.pos) * speed
					dist.y = 0
					linear_velocity = dist
				else:
					linear_velocity = Vector3.ZERO
	
	prevTime = time
