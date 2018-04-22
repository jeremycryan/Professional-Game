extends TileMap
signal collided
signal hit
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Player_body_entered(body):
	if body.is_in_group("floor"):
		emit_signal("collided");
	if (body.is_in_group("enemy") or body.get_parent().is_in_group("enemy")):
		emit_signal("hit");
