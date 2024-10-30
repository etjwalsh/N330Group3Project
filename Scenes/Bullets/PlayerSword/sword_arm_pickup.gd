extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#function for picking up the sword object
func _on_body_entered(body: Node3D) -> void:
	#check if the body that entered the area is the player
	if body.name == "Player":
		#enable the sword arm on the player script
		
		#delete the sword object
		queue_free()
