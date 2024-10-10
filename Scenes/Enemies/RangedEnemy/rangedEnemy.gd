extends Node3D

var enemyHealth = 100
var shotBuffer = 100
var enemyBulletIns

const bullet = preload("res://Scenes/Bullets/RangedEnemyBullet/RangedEnemyBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EnemySprite.modulate = Color(1, .44, .45)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#despawn if health zero
	if(enemyHealth <= 0):
		queue_free()
		
	if (shotBuffer <= 0):
		shotBuffer = 100
		enemyBulletIns = bullet.instantiate()
		add_child(enemyBulletIns)
		
	else:
		shotBuffer -= 1
