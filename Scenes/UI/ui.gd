extends Control

const heart = preload("res://Images/helf.png")

var heartcount = 5
var hearts = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var unitSize = get_viewport().get_visible_rect().size.x / 20
	for i in heartcount:
		hearts.append(Sprite2D.new())
		hearts[-1].position = Vector2(i * unitSize * 1.1, 0)
		hearts[-1].scale = Vector2(unitSize / 16, unitSize / 16)
		hearts[-1].texture = heart
		hearts[-1].centered = false
		add_child(hearts[-1])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Energy.value = PlayerAutoload.energy
	
	if(PlayerAutoload.health >= 0):
		if(hearts.size() > PlayerAutoload.health):
			for i in hearts.size() - PlayerAutoload.health:
				hearts[-1].queue_free()
			hearts.resize(PlayerAutoload.health)
	else:
		PlayerAutoload.health = 0


func _on_resized() -> void:
	var unitSize = get_viewport().get_visible_rect().size.x / 20
	for i in hearts.size():
		hearts[i].position = Vector2(i * unitSize * 1.1, 0)
		hearts[i].scale = Vector2(unitSize / 16, unitSize / 16)
	
	$Energy.size = get_viewport().get_visible_rect().size / Vector2(40, 2)
	$Energy.position = Vector2(get_viewport().get_visible_rect().size.x - $Energy.size.x, 0)
