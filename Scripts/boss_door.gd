extends Node3D
var pickupsArr = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#add both arm pickups to an array
	for child in $Pickups.get_children():
		pickupsArr.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#loop thru array of arm pickups
	for i in pickupsArr.size():
		#checks to see if both of the arms have been picked up
		if not is_instance_valid(pickupsArr[1]) and not is_instance_valid(pickupsArr[0]):
			#delete the door to the boss
			$Door.position = Vector3(-10,-10,-10)
			print('door opened')
			self.queue_free() #so that the loop ends when the door opens
