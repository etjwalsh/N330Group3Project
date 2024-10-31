extends Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
@onready var playerRef = $"../Player"

#function for picking up the sword object
func _on_body_entered(body: Node3D) -> void:
	
	#check if the body that entered the area is the player
	if body.name == "Player":
		#enable the sword arm on the player script
		print_debug(playerRef.laserUsable)
		playerRef.laserUsable = true
		print_debug(playerRef.laserUsable)
		
		#delete the sword object
		queue_free()
