extends CharacterBody3D

var weaponNum = 3
#0: spreadshot
#1: laser
#2: sword
var weapon = 0

const wideshotAngle = PI/8
const wideshotBuffMax = .08
const energyUse = 200
const energyGain = 100
const dashSpeed = 30.0
const walkSpeed = 15.0

var bulletSpawn = .516
var wideshotBuffer = 0
var weaponRotation = 0
var bulletIns
var laserIns
var swordIns
var speed = walkSpeed
var canDash = true

const bullet = preload("res://Scenes/Bullets/PlayerBullet/player_bullet.tscn")
const laser = preload("res://Scenes/Bullets/PlayerLaser/player_laser.tscn")
const sword = preload("res://Scenes/Bullets/PlayerSword/player_sword.tscn")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

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
	move_and_slide()

func _process(delta: float) -> void:
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
				if(!is_instance_valid(laserIns)):
					laserIns = laser.instantiate()
					add_child(laserIns)
				laserIns.rotation.y = weaponRotation
			2:
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
	
	#roll system
	"""
	if(Input.is_action_just_pressed("dash"))
		if canDash:
			$DashTimer.start()
			SPEED += 35.0
			canDash = false
			$AnimatedSprite3D.modulate = Color(0, 1, 1) # REMOVE LATER
	"""
	#dash system (lines 90 to 101)
	if(Input.is_action_pressed("dash")):
		PlayerAutoload.energy -= energyUse * delta
		if(PlayerAutoload.energy < 0):
			PlayerAutoload.energy = 0
			speed = walkSpeed
		else:
			speed = dashSpeed
	else:
		PlayerAutoload.energy += energyGain * delta
		if(PlayerAutoload.energy > 100):
			PlayerAutoload.energy = 100
		speed = walkSpeed

func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		weaponRotation = -Vector2(960, 540).angle_to_point(event.position) + PI/2

func _on_dash_timer_timeout() -> void:
	speed = 15
	$DashCooldown.start()
	$AnimatedSprite3D.modulate = Color(1, 1, 1) # REMOVE LATER

func _on_dash_cooldown_timeout() -> void:
	canDash = true