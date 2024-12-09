extends CharacterBody3D

var weaponNum = 3
#0: spreadshot
#1: laser
#2: sword
var weapon = 0

const wideshotAngle = PI/8
const wideshotBuffMax = .08
const energyUse = 100
const energyGain = 100
const energyLag = .3
const dashSpeed = 18
const walkSpeed = 8
const itimeLim = 1

var bulletSpawn = .516
var wideshotBuffer = 0
var weaponRotation = 0
var bulletIns
var laserIns
var swordIns
var speed = walkSpeed
var canDash = true
var energyLagTimer = 0
var energyUsed = false
var health = 5 
var itime = itimeLim

const bullet = preload("res://Scenes/Bullets/PlayerBullet/player_bullet.tscn")
const laser = preload("res://Scenes/Bullets/PlayerLaser/player_laser.tscn")
const sword = preload("res://Scenes/Bullets/PlayerSword/player_sword.tscn")

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	PlayerAutoload.pos = position
	move_and_slide()

func _process(delta: float) -> void:
	
	if(itime != itimeLim):
		itime += delta
		if(int(itime * 15) % 2):
			$AnimatedSprite3D.visible = true
		else:
			$AnimatedSprite3D.visible = false
		if(itime > itimeLim):
			itime = itimeLim
			$AnimatedSprite3D.visible = true
	
	if(health != PlayerAutoload.health):
		PlayerAutoload.health = health
		if(health <= 0):
			get_parent().get_parent().add_child(load("res://Scenes/Screens/GameOverScreen/game_over_screen.tscn").instantiate())
			get_parent().queue_free()
	
	#print_debug(swordUsable)
	if(Input.is_action_pressed("use")):
		match(weapon):
			0:
				if(wideshotBuffer == 0):
					bulletIns = bullet.instantiate()
					bulletIns.rotation.y = weaponRotation + (wideshotAngle * (bulletSpawn - .5))
					bulletIns.position = position
					bulletSpawn += 0.618
					if(bulletSpawn > 1):
						bulletSpawn -= 1
					get_parent().add_child(bulletIns)
				wideshotBuffer += .5 * delta
				if(wideshotBuffer >= wideshotBuffMax):
					wideshotBuffer = 0
			1:
				if(PlayerAutoload.laserUsable == false):
					weapon = 2
				if(!is_instance_valid(laserIns)):
					laserIns = laser.instantiate()
					add_child(laserIns)
				laserIns.rotation.y = weaponRotation
			2:
				if(PlayerAutoload.swordUsable == false):
					weapon = 0
				if(!is_instance_valid(swordIns)):
					swordIns = sword.instantiate()
					add_child(swordIns)
				swordIns.rotation.y = weaponRotation
	if(is_instance_valid(laserIns) && (!Input.is_action_pressed("use") || weapon != 1)):
		laserIns.queue_free()
	if(is_instance_valid(swordIns) && (!Input.is_action_pressed("use") || weapon != 2)):
		swordIns.queue_free()
	if(Input.is_action_just_pressed("switch")):
		weapon += 1
		if(weapon >= weaponNum):
			weapon = 0
	if(Input.is_action_pressed("dash")):
		PlayerAutoload.energy -= energyUse * delta
		energyUsed = true
		if(PlayerAutoload.energy < 0):
			PlayerAutoload.energy = 0
			speed = walkSpeed
		else:
			speed = dashSpeed
	else:
		if(energyUsed):
			energyLagTimer = energyLag
			energyUsed = false
		if(energyLagTimer > 0):
			energyLagTimer -= delta
		else:
			PlayerAutoload.energy += energyGain * delta
			if(PlayerAutoload.energy > 100):
				PlayerAutoload.energy = 100
		speed = walkSpeed

func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		weaponRotation = -(get_viewport().get_visible_rect().size / 2).angle_to_point(event.position) + PI/2

func hurt():
	if(itime == itimeLim):
		health -= 1
		itime = 0
