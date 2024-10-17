extends Node3D

const bulletNum = 5
const spread = .1
const bulletSpreadDist = .5
const bulletSpeed = 15

var enemyHealth = 100
var shotBuffer = 100
var enemyBulletIns

const bullet = preload("res://Scenes/Bullets/RangedEnemyBullet/RangedEnemyBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EnemySprite.modulate = Color(1, .44, .45)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#despawn if health zero
	if(enemyHealth <= 0):
		queue_free()
		
	if (shotBuffer <= 0):
		shotBuffer = 100
		var dir = -Vector2(position.x, position.z).angle_to_point(Vector2(PlayerAutoload.pos.x, PlayerAutoload.pos.z)) + PI/2
		for i in bulletNum:
			enemyBulletIns = bullet.instantiate()
			enemyBulletIns.rotation.y = dir + ((i - floor(bulletNum / 2)) * spread)
			enemyBulletIns.bulletSpeed = bulletSpeed
			enemyBulletIns.position += enemyBulletIns.basis.z * (1 - (abs((bulletNum / 2) - i))) * bulletSpreadDist
			enemyBulletIns.position += enemyBulletIns.basis.x * (i - floor(bulletNum / 2.0)) * bulletSpreadDist
			add_child(enemyBulletIns)
	else:
		shotBuffer -= 1
