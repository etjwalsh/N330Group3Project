extends Node3D

var wideshotEnemy = preload("res://Scenes/Enemies/RangedEnemy/rangedEnemy.tscn")
var shotgunEnemy = preload("res://Scenes/Enemies/RangedEnemy2/ranged_enemy_2.tscn")
var staticEnemy = preload("res://Scenes/Enemies/RangedEnemyStatic/ranged_enemy_static.tscn")
var meleeEnemy = preload("res://Scenes/Enemies/MeleeEnemy/MeleeEnemy.tscn")

var enemyToSpawn
var maxEnemies = 10
var spawnPosX 
var spawnPosY
var spawnPosZ 

func _spawnEnemy():
	var enemyIndex = int(randi_range(0,3))
	
	match enemyIndex:
		0:
			enemyToSpawn = wideshotEnemy
		1:
			enemyToSpawn = shotgunEnemy
		2:
			enemyToSpawn = staticEnemy
		3:
			enemyToSpawn = meleeEnemy
	
	spawnPosX = randf_range(-10,10)
	spawnPosY = 0
	spawnPosZ = randf_range(-10,10)
	
	var enemyToSpawnIns = enemyToSpawn.instantiate()
	enemyToSpawnIns.position = Vector3(spawnPosX, spawnPosY, spawnPosZ)
	
	if maxEnemies > 0:
		add_child(enemyToSpawnIns)
		maxEnemies -= 1


func _on_spawn_delay_timeout() -> void:
	_spawnEnemy()
	pass # Replace with function body.
