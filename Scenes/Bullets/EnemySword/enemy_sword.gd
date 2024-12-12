extends Area3D

var time = .5
var hit = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#decreases the time until its below 0, in which case it deletes itself
	time -= delta
	if(time <= 0):
		queue_free()


func _on_body_entered(body: Node3D) -> void:
	#if this sword hits something with the "health" field, execute the hurt command.
	if("health" in body && !hit):
		body.hurt()
		hit = true
