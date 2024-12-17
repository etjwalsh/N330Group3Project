extends Node3D

var boss = preload("res://Scenes/Enemies/boss/boss.tscn")

@export var maxEnemies = 1 # export so we can change the amount of enemies spawned per instance of the object
var enemiesSpawnNum = maxEnemies
var spawnPosX 
var spawnPosY
var spawnPosZ 
var numEnemies = 0
var enemiesArr = []
var enemiesKilled = 0


func _ready():
	$BigWall.visible = false
	$BigWall.position = Vector3(-10,-10,-10)
	
func _process(delta: float) -> void:
	_open_doors(enemiesArr)
	if enemiesKilled == maxEnemies:
		$BigWall.visible = false
		$BigWall.position = Vector3(-10,-10,-10)

func _spawnEnemy():
	
	spawnPosX = randf_range($Area3D.position.x - 10, $Area3D.position.x + 10)
	spawnPosY = 0
	spawnPosZ = randf_range($Area3D.position.y - 10, $Area3D.position.y + 10)
	
	var enemyToSpawnIns = boss.instantiate()
	numEnemies += 1
	enemyToSpawnIns.position = position + Vector3(spawnPosX, spawnPosY, spawnPosZ)
	
	if enemiesSpawnNum > 0:
		get_parent().add_child(enemyToSpawnIns)
		enemiesArr.append(enemyToSpawnIns)
		enemiesSpawnNum -= 1

func _on_spawn_delay_timeout() -> void:
	_spawnEnemy()
	pass # Replace with function body.


func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body.name == "Player"):
		$spawnDelay.start()
		#close the doors
		$BigWall.position = Vector3(0,0,0)
		$BigWall.visible = true

func _open_doors(array):
	enemiesKilled = 0
	for i in array.size():
		if not is_instance_valid(array[i]):
			enemiesKilled += 1
